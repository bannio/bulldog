require 'spec_helper'

describe SuppliersController do

  login_user
  create_account

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end

    it "assigns suppliers" do
      supplier = create(:supplier, account_id: @account.id)
      get :index
      expect(assigns(:suppliers)).to eq [supplier]
    end
  end

  describe "GET #edit" do
    it "returns http success" do
      supplier = create(:supplier, account_id: @account.id)
      get :edit, id: supplier.to_param
      expect(response).to be_success
    end

    it "assigns supplier" do
      supplier = create(:supplier, account_id: @account.id)
      get :edit, id: supplier.to_param
      expect(assigns(:supplier)).to eq supplier
    end

    it "cannot see other people's suppliers" do
      supplier = create(:supplier)
      get :edit, id: supplier.to_param
      expect(assigns(:supplier)).to eq nil
    end
  end

  describe "PATCH 'update'" do
    before :each do
      @supplier = create(:supplier, account_id: @account.id)
    end

    it "assigns the supplier" do
      patch :update, id: @supplier, supplier: {name: "new name"}
      expect(assigns(:supplier)).to eq @supplier
    end

    it "doesn't assign other people's supplier" do
      supplier = create(:supplier)
      patch :update, id: supplier.to_param
      expect(assigns(:supplier)).to eq nil
    end

    it "redirects to the index" do
      patch :update, id: @supplier, supplier: {name: "new name"}
      expect(response).to redirect_to suppliers_path
    end

    it "changes the name" do
      patch :update, id: @supplier, supplier: {name: "new name"}
      expect(@supplier.reload.name).to eq "new name" 
    end

    it "deletes a supplier when the new name already existed" do
      supplier = create(:supplier, account_id: @account.id, name: "new name")
      expect{
        patch :update, id: @supplier, supplier: {name: "new name"}
        }.to change(Supplier, :count).by -1
    end
  end

end
