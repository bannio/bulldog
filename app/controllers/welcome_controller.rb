class WelcomeController < ApplicationController
  before_action :authenticate_user!
  before_action :route_according_to_account_state

  def index
  end

  private

  def route_according_to_account_state

    case current_account.state
    when "paid"
      route_paid
    when "trialing"
      check_trial_end_date
    when "paying"
      route_paying
    when "expired"
      route_expired
    when "charge_failed"
      route_charge_failed
    when "closed"
      route_closed
    when "deleted"
      route_deleted
    else
      route_contact # something went wrong
    end
  end

  def check_trial_end_date
    if current_account.trial_end < Time.now
      current_account.expire!
      route_expired
    else
      route_paid
    end
  end

  def route_paid
    # continue to index
  end

  def route_paying
    # allow 'paying' to have access to avoid 1 hour delay and assuming charge will succeed
    # added 'paying' to definition of 'active?' in account model
    # flash[:alert] = "You card payment is still being processed, please try again soon"
    # redirect_to page_path('waiting_payment')
  end

  def route_expired
    flash[:error] = "Your free_trial has ended, please supply payment card details to continue"
    redirect_to new_card_account_path(current_account)
  end

  def route_charge_failed
    flash[:error] = "A recent attempt to charge your card has failed. Please confirm your card details to continue"
    redirect_to new_card_account_path(current_account)
  end

  def route_closed
    flash[:error] = "Your account is closed, you can rejoin by subscribing here using your saved card"
    redirect_to edit_account_path(current_account)
  end

  def route_deleted
    flash[:error] = "Your account has been deleted. To re-activate it please contact us"
    sign_out current_user
    redirect_to new_contact_path
  end

  def route_contact
    flash[:error] = "Something may have gone wrong here. Please let us know what happened."
    sign_out current_user
    redirect_to new_contact_path
  end
end
