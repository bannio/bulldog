class SettingsController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized

  # Because setting is one to one with account we don't need the params[:id]
  # Access is limited to current_account only

  def index
    @setting = current_account.setting
    authorize @setting
    render :show
  end
  def show
    @setting = current_account.setting
    authorize @setting
  end

  def edit
    @setting = current_account.setting
    authorize @setting
  end

  def update
    @setting = current_account.setting
    authorize @setting
    if @setting.update(setting_params)
      redirect_to @setting
    else
      render :edit
    end
  end

  private
  def setting_params
    params.require(:setting).permit(*policy(@setting || Setting).permitted_attributes)
  end
end
