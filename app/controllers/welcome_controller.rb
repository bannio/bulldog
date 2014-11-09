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
    when "expired"
      route_expired
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

  def route_expired
    flash[:error] = "Your free_trial has ended, please supply payment card details to continue"
    redirect_to new_card_account_path(current_account)
  end

  def route_closed
    flash[:error] = "Your account is closed, you can rejoin by subscribing here"
    redirect_to edit_account_path(current_account)
  end

  def route_deleted

  end

  def route_contact

  end
end
