class InvoicesController < ApplicationController

  before_action :authenticate_user!
  helper_method :sort_column, :sort_direction

  def index
    @invoices = Invoice.visible_to(current_user).includes(:customer).
                                                customer_filter(params[:inv_customer_id]).
                                                search(params[:search]).
                                                page(params[:page]).
                                                order(sort_column + " " + sort_direction)
  end

  def show
    @invoice = Invoice.visible_to(current_user).find(params[:id])
    @customers = []
    @customers << @invoice.customer
    @bills = @invoice.bills.includes(:category, :supplier)

    respond_to do |format|
      format.html # show.html.erb
      format.pdf do
        pdf = InvoicePdf.new(@invoice, @bills, view_context)
        send_data pdf.render, filename: "invoice_#{@invoice.number}",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end

  def new
    @invoice = Invoice.new(account_id: current_account.id)
    @invoice.date = Date.today
    @customers = current_account.customers
  end

  def edit
    @invoice = Invoice.visible_to(current_user).find(params[:id])
    @customers = []
    @customers << @invoice.customer
    @bills = @invoice.bills.includes(:category, :supplier)
  end

  def update
    @invoice = Invoice.visible_to(current_user).find(params[:id])
    @customers = []
    @customers << @invoice.customer
    if params[:bill_ids]
      Bill.where('id IN (?)', params[:bill_ids]).update_all(invoice_id: nil)
    end
    total = @invoice.bills.sum(:amount)
    if @invoice.update(invoice_params.merge(total: total))
      flash[:success] = "Invoice successfully updated"
      redirect_to invoices_path
    else
      render 'edit'
    end
  end

  def create
    @invoice = Invoice.new(invoice_params)
    @invoice.number = Invoice.next_number(current_account)
    @bills =  current_account.bills.uninvoiced.where(customer_id: @invoice.customer_id)
    @invoice.total = @bills.sum(:amount)
    @customers = current_account.customers # in case of no save

    if @invoice.save
      @bills.each do |bill|
            bill.update_attribute(:invoice_id, @invoice.id)
            # bill.save
          end
      session[:new_invoice] = true
      redirect_to edit_invoice_path(@invoice)
    else
      render :new
    end
  end

  def destroy
    @invoice = Invoice.find(params[:id])
    @invoice.bills.each do |bill|
                   bill.invoice_id = nil
                   bill.save
                 end
    @invoice.destroy

    respond_to do |format|
      format.html { redirect_to invoices_url }
    end
  end

  private

  def invoice_params
    params.require(:invoice).permit(:date, :customer_id, :comment, :number, :account_id, :total)
  end

  def sort_column
    %w[id number customers.name date total comment].include?(params[:sort]) ? params[:sort] : "id"
  end

   def sort_direction
     %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
   end

end
