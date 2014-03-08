require 'spec_helper'

describe ReportsController do
  login_user
  create_account

  describe "GET #new" do
    it "assigns @report" do
      get :new, {}
      expect(assigns(:report)).to be_valid
    end
    it "assigns @bills" do
      get :new, {}
      expect(assigns(:bills)).to match_array([])
    end
  end

  describe "POST #create" do
    context "with valid data" do
      it "renders the new template" do
        post :create, {report: {account_id: @account.id}}
        expect(response).to render_template :new
      end

      it "assigns the new report as @report" do
        post :create, {report: {account_id: @account.id}}
        expect(assigns(:report)).to be_a(Report)
        expect(assigns(:report)).to_not be_persisted
      end

      it "assigns found bills as @bills" do
        post :create, {report: {account_id: @account.id}}
        expect(assigns(:bills)).to match_array([])
      end

      it "responds to Export button" do
        expect(subject).to receive(:send_data).with("Date,Customer,Supplier,Description,Amount,Invoice\n").
          and_return { subject.render nothing: true }
        post :create, {commit: "Export", report: {account_id: @account.id}}
      end
    end
    context "with invalid data" do
      it "requires an account id to be present" do
        post :create, {report: {account_id: ""}}
        expect(assigns(:report)).to_not be_valid
        expect(assigns(:report)).to have(1).error_on(:account_id)
      end
      it "renders the new template" do
        post :create, {report: {account_id: ""}}
        expect(response).to render_template :new
      end
    end
  end

end
