require 'rails_helper'

describe CategoriesController do

  login_user

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      expect(response).to be_successful
    end
  end

  describe "GET#index" do
    it "assigns categories" do
      category = create(:category, account_id: @account.id)
      get :index
      expect(assigns(:categories)).to eq [category]
    end
    it "ignores other's categories" do
      category = create(:category, account_id: @account.id)
      category2 = create(:category, account_id: @account.id + 1)
      get :index
      expect(assigns(:categories)).to eq [category]
    end
  end

  describe "GET #edit" do
    it "assigns category" do
      category = create(:category, account_id: @account.id)
      get :edit, params: {id: category.id}
      expect(assigns(:category)).to eq category
    end
    it "cannot see other people's categories" do
      category = create(:category)
      get :edit, params: {id: category.to_param}
      expect(assigns(:category)).to eq nil
    end
  end

  describe "PATCH#update" do
    before :each do
      @category = create(:category, account_id: @account.id)
    end
    it "assigns the category as @category" do
      patch :update, params: {id: @category, category: {name: "new name"}}
      expect(assigns(:category)).to eq @category
    end

    it "redirects to categories index" do
      patch :update, params: {id: @category, category: {name: "new name"}}
      expect(response).to redirect_to categories_path
    end

    it "changes the name" do
      patch :update, params: {id: @category, category: {name: "new name"}}
      expect(@category.reload.name).to eq "new name"
    end

    it "deletes a category when the new name already existed" do
      category = create(:category, account_id: @account.id, name: "new name")
      expect{
        patch :update, params: {id: @category, category: {name: "new name"}}
        }.to change(Category, :count).by -1
    end
  end

end
