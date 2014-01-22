class AccountsController < ApplicationController

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
    if @account.update(params[:account].permit(:name, :address, :postcode))
      flash[:success] = "Account successfully updated"
      redirect_to @account
    else
      render 'edit'
    end
  end
end
