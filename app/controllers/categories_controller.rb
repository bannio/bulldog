class CategoriesController < ApplicationController
  before_action :authenticate_user!

  def index
    @categories = Category.visible_to(current_user).order(name: :asc)
  end

  def edit
    @category = Category.visible_to(current_user).find(params[:id])
  end

  def update
    @category = Category.visible_to(current_user).find(params[:id])
    old_name = @category.name
    new_name = params[:category][:name]

    if Category.visible_to(current_user).where(name: new_name).empty? && new_name != old_name
      @category.update_attribute(:name, new_name)
      flash[:success] = "category #{old_name} renamed to #{new_name}" 
    else
      unless new_name == old_name
        @category.reassign_bills_to(new_name)
        @category.destroy
        flash[:success] = "category #{old_name} deleted and bills assigned to #{new_name}"
      end
    end
    redirect_to categories_url
  end

end
