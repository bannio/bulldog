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
    call_update_card_service(@account)
    if @account.errors.empty?
      if @account.active?
        flash[:success] = "Thankyou. Your card details have been updated"
        redirect_to @account
      else
        flash[:success] = "Thankyou. Your card details have been updated"
        sign_out current_user
        redirect_to page_path('waiting_payment')
      end
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
    UpdateAccount.call(@account)
    if @account.errors.empty?
      if @account.closed?
        sign_out current_user
        redirect_to page_path('goodbye')
      else
        redirect_to @account, notice: "Account successfully updated"
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

  def call_update_card_service(account)
    account = UpdateCard.call({
      account: account,
      token: params[:account][:stripe_card_token]
      })
    # account.add_card! if account.errors.empty?
    # account
    Rails.logger.info "account errors: #{account.errors.full_messages}"
    account
  end

  def account_params
    params.require(:account).permit(*policy(@account || Account).permitted_attributes)
  end

  def record_not_found
    flash[:error] = "You don't have access to that account"
    # begin
      # redirect_to :back
      redirect_back(fallback_location: root_path)
    # rescue ActionController::RedirectBackError
    #   redirect_to root_path
    # end
  end

  def is_cancellation?
    params[:account][:plan_id] == "0"
  end
end
