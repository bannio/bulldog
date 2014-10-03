class SuppliersController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized

  def index
    @suppliers = current_account.suppliers.order(name: :asc)
    authorize @suppliers
  end

  def edit
    @supplier = current_account.supplier(params[:id])
    authorize @supplier
  end

  def update
    @supplier = current_account.supplier(params[:id])
    authorize @supplier
    old_name = @supplier.name
    new_name = supp_params[:name]

    if current_account.suppliers.where(name: new_name).empty? && new_name != old_name
      @supplier.update_attribute(:name, new_name)
      flash[:success] = "supplier #{old_name} renamed to #{new_name}"
    else
      unless new_name == old_name
        @supplier.reassign_bills_to(new_name)
        @supplier.destroy
        flash[:success] = "supplier #{old_name} deleted and bills assigned to #{new_name}"
      end
    end
    redirect_to suppliers_url
  end

  def supp_params
    params.require(:supplier).permit(*policy(@supplier || Supplier).permitted_attributes)
  end
end