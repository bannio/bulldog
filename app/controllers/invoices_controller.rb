class InvoicesController < ApplicationController

  before_action :authenticate_user!

  def index
    @invoices = Invoice.visible_to(current_user)
  end

  def show
    @invoice = Invoice.find(params[:id])
    @customers = []
    @customers << @invoice.customer
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
  end

  def update
    @invoice = Invoice.visible_to(current_user).find(params[:id])
    @customers = []
    @customers << @invoice.customer
    if params[:bill_ids]
      Bill.where('id IN (?)', params[:bill_ids]).update_all(invoice_id: nil)
    end
    if @invoice.update(invoice_params)
      flash[:success] = "Invoice successfully updated"
      redirect_to invoice_path(@invoice)
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
            bill.save
          end
      redirect_to invoice_path(@invoice)
    else
      render :new
    end
  end

  private

  def invoice_params
    params.require(:invoice).permit(:date, :customer_id, :comment, :number, :account_id, :total)
  end
end
