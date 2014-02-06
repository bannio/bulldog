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
                                 :date, :category_id, :description, :amount)
  end
end
