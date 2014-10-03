class VatRatesController < ApplicationController

  before_action :authenticate_user!
  after_action :verify_authorized
  after_action :verify_policy_scoped, except: [:new, :create]

  def index
    @vat_rates = policy_scope(VatRate).order(name: :asc )
    authorize @vat_rates
    @vat_rates = @vat_rates.active unless params[:all]
  end

  def new
    @vat_rate = current_account.vat_rates.build(active: true)
    authorize @vat_rate
  end

  def create
    @vat_rate = VatRate.new(vat_params)
    authorize @vat_rate
    if @vat_rate.save
      redirect_to vat_rates_url, notice: "VAT rate successfully added"
    else
      render :new
    end
  end

  def edit
    @vat_rate = policy_scope(VatRate).find(params[:id])
    authorize @vat_rate
  end

  def update
    @vat_rate = policy_scope(VatRate).find(params[:id])
    authorize @vat_rate
    if @vat_rate.update_attributes(vat_params)
      redirect_to vat_rates_url, notice: "VAT rate successfully updated"
    else
      render :edit
    end
  end

  def destroy
    @vat_rate = policy_scope(VatRate).find(params[:id])
    authorize @vat_rate
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
    params.require(:vat_rate).permit(*policy(@vat_rate || VatRate).permitted_attributes)
  end

end
