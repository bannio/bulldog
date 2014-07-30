class TransactionsController < ApplicationController
  before_action :authenticate_user!, except: [:new, :create]

  def new
    @plan = Plan.find(params[:plan_id])
  end

  def create
    
  end

  private

  def transaction_params
    # params.require(:xxxt).permit(:xxx, :yyy)
  end
end