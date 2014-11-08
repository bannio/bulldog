class AccountsController < ApplicationController
  before_action :authenticate_user!, except: [:new, :create]
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  after_action :verify_authorized

  def show
    @account = Account.owned_by_user(current_user).find(params[:id])
    authorize @account
  end

  def new
    plan = Plan.find(params[:plan_id])
    @account = plan.accounts.build
    authorize @account
    @title = params[:title]
    @price = params[:price]
    @interval = params[:interval]
  end

  def new_card
    @account = policy_scope(Account).find(params[:id])
    authorize @account
  end

  def update_card
    @account = policy_scope(Account).find(params[:id])
    authorize @account
    success = update_card_service
    if success
      flash[:success] = "Thankyou. Your card details have been updated"
      redirect_to @account
    else
      flash[:error] = "There was a problem with your payment card"
      render :new_card
    end
  end

  def edit
    @account = Account.owned_by_user(current_user).find(params[:id])
    authorize @account
  end

  def update
    @account = Account.find(params[:id])
    authorize @account
    @account.assign_attributes(account_params)
    if UpdateAccount.new(@account).update
    # if @account.update(account_params)
      if @account.active?
        redirect_to @account, notice: "Account successfully updated"
      else
        sign_out current_user
        redirect_to page_path('goodbye')
      end
    else
      if is_cancellation?
        flash[:error] = "There was a problem with this transaction"
        render 'show'
      else
        flash[:error] = "There was a problem with this transaction"
        render 'edit'
      end
    end
  end

  def create
    @account = Account.new(account_params)
    authorize @account
    @account = CreateAccount.call(account_params)
    if @account.persisted?
      redirect_to page_path('new_account')
    else
      flash[:error] = @account.errors.full_messages
      render 'new'
    end
  end

  def cancel
    @account = Account.owned_by_user(current_user).find(params[:id])
    authorize @account
  end

  private

  def update_card_service
    CardService.new({
      account: @account,
      token: params[:account][:stripe_card_token]
      }).update_card
  end

  def account_params
    params.require(:account).permit(*policy(@account || Account).permitted_attributes)
  end

  def record_not_found
    flash[:error] = "You don't have access to that account"
    begin
      redirect_to :back
    rescue ActionController::RedirectBackError
      redirect_to root_path
    end
  end

  def is_cancellation?
    params[:account][:plan_id] == "0"
  end
end
