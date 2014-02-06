require 'spec_helper'

describe BillsController do
  login_user
  create_account

  describe "GET #edit" do
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
    end
    
  end

end
