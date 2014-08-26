class CategoriesController < ApplicationController
  before_action :authenticate_user!

  def index
    @categories = current_account.categories.order(name: :asc)
  end

  def edit
    @category = current_account.category(params[:id])
  end

  def update
    @category = current_account.category(params[:id])
    old_name = @category.name
    new_name = params[:category][:name]

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

end
