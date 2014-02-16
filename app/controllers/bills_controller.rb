class BillsController < ApplicationController
  before_action :authenticate_user!

  def index
    @bills = current_account.bills
  end

  def new
    @bill = Bill.new(account_id: current_account.id)
    @bill.date = Date.today
  end

  def create
    collect_new_entries
    @bill = Bill.new(bill_params)
    if @bill.save
      redirect_to bills_url, notice: 'Bill was succesfully created'
    else
      render 'new'
    end
  end

  def edit
    @bill = Bill.find(params[:id])
  end

  def update
    collect_new_entries
    @bill = Bill.find(params[:id])
    if @bill.update(bill_params)
      flash[:success] = "Bill successfully updated"
      redirect_to bills_path
    else
      render 'edit'
    end
  end

  private
  def bill_params
    params.require(:bill).permit(:account_id, :customer_id, :supplier_id, 
                                 :date, :category_id, :description, :amount, 
                                 :new_customer, :new_supplier, :new_category)
  end

  def collect_new_entries
    params[:bill][:new_supplier] =  params[:bill][:supplier_id] if params[:bill][:supplier_id].to_i == 0
    params[:bill][:new_customer] =  params[:bill][:customer_id] if params[:bill][:customer_id].to_i == 0
    params[:bill][:new_category] =  params[:bill][:category_id] if params[:bill][:category_id].to_i == 0
  end
end
