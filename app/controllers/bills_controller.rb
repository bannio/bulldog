class BillsController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized
  # after_action :verify_policy_scoped, except: [:new, :create]
  helper_method :sort_column, :sort_direction

  def index
    @bills = current_account.bills.uninvoiced.includes(:customer, :supplier, :category, :vat_rate).
                                              page(params[:page]).
                                              order(sort_column + " " + sort_direction)
    authorize @bills
    respond_to do |format|
      format.html
      format.csv  { 
        @bills = current_account.bills.includes(:customer, :supplier, :category, :vat_rate)
        send_data @bills.to_csv, filename: 'BulldogClip_bills.csv' unless @bills.empty?
      }
      format.js
    end
  end

  def new
    @bill = current_account.bills.build
    authorize @bill
    @bill.date = Date.today
    @bill.customer_id = default_customer.id if default_customer
  end

  def create
    collect_new_entries
    @bill = Bill.new(bill_params)
    authorize @bill
    if @bill.save
      redirect_to bills_url, notice: 'Bill was succesfully created'
    else
      render 'new'
    end
  end

  def edit
    # @bill = current_account.bill(params[:id])
    @bill = policy_scope(Bill).find(params[:id])
    authorize @bill
  end

  def update
    collect_new_entries
    @bill = current_account.bill(params[:id])
    authorize @bill
    if @bill.update(bill_params)
      flash[:success] = "Bill successfully updated"
      respond_to do |format|
        format.html {redirect_to bills_url}
        format.js {redirect_to bills_url, remote: true}
      end
    else
      render 'edit'
    end
  end

  def destroy
    @bill = current_account.bill(params[:id])
    authorize @bill
    if @bill.destroy
      flash[:success] = "Bill successfully deleted"
      redirect_to bills_url, status: 303
    else
      render 'edit'
    end
  end

  private
  
  def bill_params
    params.require(:bill).permit(*policy(@bill || Bill).permitted_attributes)
  end

  def collect_new_entries
    params[:bill][:new_supplier] =  params[:bill][:supplier_id] if params[:bill][:supplier_id].to_i == 0
    params[:bill][:new_customer] =  params[:bill][:customer_id] if params[:bill][:customer_id].to_i == 0
    params[:bill][:new_category] =  params[:bill][:category_id] if params[:bill][:category_id].to_i == 0
  end

  def sort_column
    %w[date customers.name suppliers.name categories.name description amount].include?(params[:sort]) ? params[:sort] : "date"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end

  def default_customer
    @default_customer ||= current_account.customers.is_default.first
  end
end
