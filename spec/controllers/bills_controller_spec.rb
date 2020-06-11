require 'rails_helper'

describe BillsController do

  login_user

  # before(:each) do
  #   @request.env["devise.mapping"] = Devise.mappings[:user]
  #   @user = FactoryBot.create(:user)
  #   @account = FactoryBot.create(:account, user_id: @user.id)
  #   @user.confirm!
  #   sign_in :user, @user
  # end

  describe "GET #new" do
    context "with default customer set" do
      it "finds the default customer" do
        default_customer = create(:customer, account_id: @account.id, is_default: true)
        get :new
        expect(assigns(:bill).customer_id).to eq default_customer.id
      end
    end
    context "with no default customer set" do
      it "still assigns a bill" do
        get :new
        expect(assigns(:bill)).to be_a_new(Bill)
      end
    end
  end

  describe "GET #edit" do
    context "with valid data" do
      it "assigns the requested bill as @bill" do
        bill = create(:bill, account_id: @account.id)
        get :edit, params: {id: bill}
        expect(assigns(:bill)).to eq bill
      end

      it "renders the edit template" do
        bill = create(:bill, account_id: @account.id)
        get :edit, params: {id: bill}
        expect(response).to render_template :edit
      end
      it "renders the edit template (ajax)" do
        bill = create(:bill, account_id: @account.id)
        get :edit, params: {id: bill}, xhr: true
        expect(response).to render_template :edit
      end
    end
    context "bill is not on your account" do
      it "redirects to home if unauthorised" do
        bill = create(:bill, account_id: @account.id + 1)
        get :edit, params: {id: bill}
        expect(response).to redirect_to home_path
      end
    end
  end

  describe "PATCH #update" do
    before :each do
      @bill = create(:bill, account_id: @account.id,
                            description: "large bill",
                            amount: 10)
    end

    context "with valid entries" do
      it "finds the bill in question" do
        patch :update, params: {id: @bill, bill: attributes_for(:bill)}
        expect(assigns(:bill)).to eq(@bill)
      end
      it "applies the requested changes" do
        patch :update, params: {id: @bill, bill: attributes_for(:bill,
          description: "New bill")}
        @bill.reload
        expect(@bill.description).to eq "New bill"
      end
      it "redirects to the bills index" do
        patch :update, params: {id: @bill, bill: attributes_for(:bill)}
        expect(response).to redirect_to bills_path
      end
    end

    context "with invalid attributes" do
      it "does not save the updated bill to the database" do
        patch :update, params: {id: @bill, bill: attributes_for(:bill).merge(amount: "")}
        expect(@bill.amount).to eq 10
      end
      it "renders the edit template" do
        patch :update, params: {id: @bill, bill: attributes_for(:bill).merge(amount: "")}
        expect(response).to render_template :edit
      end

      it "will not edit someone else's bill" do
        other_bill = create(:bill, account_id: @account.id + 1,
                            description: "large bill",
                            amount: 10)
        patch :update, params: {id: other_bill, bill: {amount: "10"}}
        expect(response).to redirect_to home_path
      end
    end

  end

  describe "POST #create" do

    before do
      @customer = FactoryBot.create(:customer, account_id: @account.id)
      @supplier = FactoryBot.create(:supplier, account_id: @account.id)
      @category = FactoryBot.create(:category, account_id: @account.id)
    end

    context "with valid parameters" do
      it "creates a new bill" do
        expect {
          post :create, params: {bill: attributes_for(:bill).except(:invoice_id).
                                                    merge(category_id: @category.id,
                                                          supplier_id: @supplier.id,
                                                          customer_id: @customer.id,
                                                          account_id: @account.id)}
        }.to change(Bill, :count).by(1)
      end

      it "redirects to bills index" do
        post :create, params: {bill: attributes_for(:bill).except(:invoice_id).
                                                    merge(category_id: @category.id,
                                                          supplier_id: @supplier.id,
                                                          customer_id: @customer.id,
                                                          account_id: @account.id)}
        expect(response).to redirect_to bills_url
      end
    end

    context "with invalid parameters" do
      it "re-renders the new template" do
        post :create, params: {bill: attributes_for(:bill).except(:invoice_id).
                                                    merge(category_id: "",
                                                          supplier_id: "",
                                                          account_id: @account.id)}
        expect(response).to render_template "new"
      end

      it "re-renders the new template when same 'new' entered twice" do
        supplier = create(:supplier, name: "new_supplier",account_id: @account.id)
        post :create, params: {bill: attributes_for(:bill).except(:invoice_id).
                                                    merge(category_id: "1",
                                                          supplier_id: "new_supplier",
                                                          customer_id: "1",
                                                          account_id: @account.id)}
        expect(response).to render_template "new"
      end
    end
  end

  describe "DELETE destroy" do
    context "with invoice number null" do
      before :each do
        @bill = create(:bill, account_id: @account.id)
      end

      it "destroys the requested bill" do
        expect{
          delete :destroy, params: {id: @bill.to_param}
        }.to change(Bill, :count).by(-1)
      end
      it "redirects to the bills index" do
        delete :destroy, params: {id: @bill.to_param}
        expect(response).to redirect_to bills_url
      end
      it "does not destroy other account's bills" do
        bill = create(:bill, account_id: @account.id + 1)
        delete :destroy, params: {id: bill.to_param}
        expect(response).to redirect_to home_url
      end
    end

    context "with an invoice number" do
      it "does not destroy the bill" do
        @bill = create(:bill, account_id: @account.id, invoice_id: "1")
        expect{
          delete :destroy, params: {id: @bill.to_param}
        }.to change(Bill, :count).by(0)
      end
    end
  end
end
