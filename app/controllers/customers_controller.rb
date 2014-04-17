class CustomersController < ApplicationController
  before_action :authenticate_user!

  def index
    @customers = current_account.customers if current_account
  end

  def new
    @customer = current_account.customers.build
  end

  def create
    @customer = Customer.new(cust_params)
    if @customer.save
      redirect_to customers_path, notice: "Customer successfully created"
    else
      render :new
    end
  end

  def edit
    @customer = Customer.visible_to(current_user).find(params[:id])
  end

  def update
    @customer = Customer.visible_to(current_user).find(params[:id])
    if @customer.update_attributes(cust_params)
      redirect_to customers_url, notice: "Customer successfully updated"
    else
      render :edit
    end
  end

  def destroy
    @customer = Customer.find(params[:id])
    if @customer.destroy
      msg = "#{@customer.name} destroyed"
    else
      msg = "#{@customer.name} has bills in the system"
    end
    redirect_to customers_url, notice: msg
  end

  private

  def cust_params
    params.require(:customer).permit(:account_id, :name, :address, :postcode)
  end
end
