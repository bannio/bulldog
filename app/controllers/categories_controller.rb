class CategoriesController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized

  def index
    @categories = current_account.categories.order(name: :asc)
    authorize @categories
  end

  def edit
    @category = current_account.category(params[:id])
    authorize @category
  end

  def update
    @category = current_account.category(params[:id])
    authorize @category
    old_name = @category.name
    new_name = cat_params[:name]

    if current_account.categories.where(name: new_name).empty? && new_name != old_name
      if @category.update(name: new_name)
        flash[:success] = "category #{old_name} renamed to #{new_name}"
      else
        render :edit
        return
      end
    else
      unless new_name == old_name #|| new_name == ''
        @category.reassign_bills_to(new_name)
        @category.destroy
        flash[:success] = "category #{old_name} deleted and bills assigned to #{new_name}"
      end
    end
    redirect_to categories_url
  end

    private

  def cat_params
    params.require(:category).permit(*policy(@category || Category).permitted_attributes)
  end

end
