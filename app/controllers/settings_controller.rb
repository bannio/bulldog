class SettingsController < ApplicationController
  before_action :authenticate_user!

  # Because setting is one to one with account we don't need the params[:id]
  # Access is limited to current_account only

  def index
    @setting = current_account.setting
    render :show
  end
  def show
    @setting = current_account.setting
  end

  def edit
    @setting = current_account.setting
  end

  def update
    @setting = current_account.setting
    if @setting.update(setting_params)
      redirect_to @setting
    else
      render :edit
    end
  end

  private
  def setting_params
    params.require(:setting).permit(:account_id, :name, :address, :postcode, 
      :bank_account_name, :bank_name, :bank_address, 
      :bank_account_no, :bank_sort, :bank_bic, :bank_iban, :vat_reg_no,
      :include_vat, :include_bank, :telephone, :email, :logo)
  end
end
