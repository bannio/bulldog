class SettingsController < ApplicationController
  before_action :authenticate_user!

  def index
    @setting = Setting.visible_to(current_user).first
    render :show
  end
  def show
    @setting = Setting.visible_to(current_user).find(params[:id])
  end

  def edit
    @setting = Setting.visible_to(current_user).find(params[:id])
  end

  def update
    @setting = Setting.visible_to(current_user).find(params[:id])
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
