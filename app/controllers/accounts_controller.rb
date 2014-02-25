class AccountsController < ApplicationController
  before_action :authenticate_user!
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def show
    @account = Account.owned_by_user(current_user).find(params[:id])
  end
  def new
    @account = Account.new
  end

  def edit
    @account = Account.owned_by_user(current_user).find(params[:id])
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
      redirect_to @account
    else
      render 'new'
    end
  end

  private

  def account_params
    params.require(:account).permit(:name, :address, :postcode, 
      :include_bank, :bank_account_name, :bank_name, :bank_address, 
      :bank_account_no, :bank_sort, :bank_bic, :bank_iban, :invoice_heading)
  end

  def record_not_found
    flash[:error] = "You don't have access to that account"
    begin
      redirect_to :back
    rescue ActionController::RedirectBackError
      redirect_to root_path
    end
  end
end
