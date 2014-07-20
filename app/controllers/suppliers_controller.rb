class SuppliersController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @suppliers = Supplier.visible_to(current_user).order(name: :asc)
  end

  def edit
    @supplier = Supplier.visible_to(current_user).find(params[:id])
  end

  def update
    @supplier = Supplier.visible_to(current_user).find(params[:id])
    old_name = @supplier.name
    new_name = params[:supplier][:name]

    if Supplier.visible_to(current_user).where(name: new_name).empty? && new_name != old_name
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
end