class CustomersController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized

  def index
    @customers = current_account.customers if current_account
    authorize @customers
  end

  def new
    @customer = current_account.customers.build
    authorize @customer
  end

  def create
    @customer = Customer.new(cust_params)
    authorize @customer
    if @customer.save
      redirect_to customers_path, notice: "Customer successfully created"
    else
      render :new
    end
  end

  def edit
    @customer = current_account.customer(params[:id])
    authorize @customer
  end

  def update
    @customer = current_account.customer(params[:id])
    authorize @customer
    if @customer.update_attributes(cust_params)
      redirect_to customers_url, notice: "Customer successfully updated"
    else
      render :edit
    end
  end

  def destroy
    @customer = current_account.customer(params[:id])
    authorize @customer
    if @customer.destroy
      msg = "#{@customer.name} destroyed"
    else
      msg = "#{@customer.name} has bills in the system"
    end
    redirect_to customers_url, notice: msg
  end

  private

  def cust_params
    params.require(:customer).permit(*policy(@customer || Customer).permitted_attributes)
  end
end
