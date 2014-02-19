require 'spec_helper'

describe BillsController do
  login_user
  create_account

  describe "GET #edit" do
    context "with valid data" do
      it "assigns the requested bill as @bill" do
        bill = create(:bill, account_id: @account.id)
        get :edit, id: bill
        expect(assigns(:bill)).to eq bill
      end

      it "renders the edit template" do
        bill = create(:bill, account_id: @account.id)
        get :edit, id: bill
        expect(response).to render_template :edit
      end
    end
    context "bill is not on your account" do
      it "redirects to home if unauthorised" do
        bill = create(:bill, account_id: @account.id + 1)
        get :edit, id: bill
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
        patch :update, id: @bill, bill: attributes_for(:bill)
        expect(assigns(:bill)).to eq(@bill)
      end
      it "applies the requested changes" do
        patch :update, id: @bill, bill: attributes_for(:bill,
          description: "New bill")
        @bill.reload
        expect(@bill.description).to eq "New bill"
      end
      it "redirects to the bills index" do
        patch :update, id: @bill, bill: attributes_for(:bill)
        expect(response).to redirect_to bills_path
      end
    end

    context "with invalid attributes" do
      it "does not save the updated bill to the database" do
        patch :update, id: @bill, bill: attributes_for(:bill).merge(amount: "")
        expect(@bill.amount).to eq 10
      end
      it "renders the edit template" do
        patch :update, id: @bill, bill: attributes_for(:bill).merge(amount: "")
        expect(response).to render_template :edit
      end

      it "will not edit someone else's bill" do
        other_bill = create(:bill, account_id: @account.id + 1,
                            description: "large bill",
                            amount: 10)
        patch :update, id: other_bill, bill: {amount: "10"}
        expect(response).to redirect_to home_path
      end
    end
    
  end

  describe "POST #create" do

    context "with valid parameters" do
      it "creates a new bill" do
        expect {
          post :create, bill: attributes_for(:bill).except(:invoice_id).
                                                    merge(category_id: "1",
                                                          supplier_id: "1",
                                                          account_id: @account.id)
        }.to change(Bill, :count).by(1)
      end

      it "redirects to bills index" do
        post :create, bill: attributes_for(:bill).except(:invoice_id).
                                                    merge(category_id: "1",
                                                          supplier_id: "1",
                                                          account_id: @account.id)
        expect(response).to redirect_to bills_url
      end
    end

    context "with invalid parameters" do
      it "re-renders the new template" do
        post :create, bill: attributes_for(:bill).except(:invoice_id).
                                                    merge(category_id: "",
                                                          supplier_id: "",
                                                          account_id: @account.id)
        expect(response).to render_template "new"
      end
    end
  end

end
