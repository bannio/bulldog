class VatRatesController < ApplicationController

  before_action :authenticate_user!

  def index
    @vat_rates = VatRate.visible_to(current_user).order(name: :asc )
    @vat_rates = @vat_rates.active unless params[:all]
    # @vat_rates = current_account.vat_rates if current_account
  end

  def new
    @vat_rate = current_account.vat_rates.build(active: true)
  end

  def create
    @vat_rate = VatRate.new(vat_params)
    if @vat_rate.save
      redirect_to vat_rates_url, notice: "VAT rate successfully added"
    else
      render :new
    end
  end

  def edit
    @vat_rate = VatRate.visible_to(current_user).find(params[:id])
  end

  def update
    @vat_rate = VatRate.visible_to(current_user).find(params[:id])
    if @vat_rate.update_attributes(vat_params)
      redirect_to vat_rates_url, notice: "VAT rate successfully updated"
    else
      render :edit
    end
  end

  def destroy
    @vat_rate = VatRate.visible_to(current_user).find(params[:id])
    if @vat_rate.destroy
      flash[:success] = "VAT rate successfully deleted"
      redirect_to :vat_rates
    else
      flash[:error] = "This rate is in use and cannot be deleted"
      # render :edit
      redirect_to :vat_rates
    end
  end

  private

  def vat_params
    params.require(:vat_rate).permit(:account_id, :name, :rate, :active)
  end

end
