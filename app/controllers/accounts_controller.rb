class AccountsController < ApplicationController
  before_action :authenticate_user!

  def show
    @account = Account.find(params[:id])
  end
  def new
    @account = Account.new
  end

  def edit
    @account = Account.find(params[:id])
  end

  def update
    @account = Account.find(params[:id])
    if @account.update(account_params)
      flash[:success] = "Account successfully updated"
      redirect_to @account
    else
      render 'edit'
    end
  end

  def create
    @account = Account.new(account_params)
    @account.user_id = current_user.id
    if @account.save
      flash[:success] = "Account successfully created"
      redirect_to home_path
    else
      render 'edit'
    end
  end

  private

  def account_params
    params.require(:account).permit(:name, :address, :postcode)
  end
end
