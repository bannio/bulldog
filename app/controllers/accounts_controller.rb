class AccountsController < ApplicationController
  before_action :authenticate_user!, except: [:new, :create]
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def show
    @account = Account.owned_by_user(current_user).find(params[:id])
  end
  def new
    plan = Plan.find(params[:plan_id])
    @account = plan.accounts.build
  end

  def edit
    @account = Account.owned_by_user(current_user).find(params[:id])
  end

  def update
    @account = Account.find(params[:id])
    if @account.update(account_params)
      # flash[:notice] = "Account successfully updated"
      redirect_to @account, notice: "Account successfully updated"
    else
      render 'edit'
    end
  end

  # should this be removed? Accounts are set up at user confirmation
  def create
    @account = Account.new(account_params)
    if @account.save_with_payment

      redirect_to home_path, notice: "Thanks for subscribing. A confirmation link has been sent to your email address. Please open the link to activate your account."
    else
      flash[:error] = @account.errors[:base][0]
      render 'new'
    end

    # @account.user_id = current_user.id
    # if @account.save
    #   flash[:success] = "Account successfully created"
    #   redirect_to @account
    # else
    #   render 'new'
    # end
  end

  private

  def account_params
    params.require(:account).permit(:name, :address, :postcode, 
      :include_bank, :bank_account_name, :bank_name, :bank_address, 
      :bank_account_no, :bank_sort, :bank_bic, :bank_iban, :invoice_heading,
      :vat_enabled, :plan_id, :email, :stripe_customer_token, :user_id,
      :stripe_card_token)
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
