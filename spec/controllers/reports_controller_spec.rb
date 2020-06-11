require 'rails_helper'

describe ReportsController do

  login_user

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
        post :create, params: {report: {account_id: @account.id}, commit: "View"}
        expect(response).to render_template :new
      end

      it "assigns the new report as @report" do
        post :create, params: {report: {account_id: @account.id}, commit: "View"}
        expect(assigns(:report)).to be_a(Report)
        expect(assigns(:report)).to_not be_persisted
      end

      it "assigns found bills as @bills" do
        post :create, params: {report: {account_id: @account.id}, commit: "View"}
        expect(assigns(:bills)).to match_array([])
      end

      it "responds to Export button" do
        pending "awaiting way to test csv creation without setting up complete bill hierarchy"
        fail
      end
    end
    context "with invalid data" do
      it "requires an account id to be present" do
        post :create, params: {report: {account_id: ""}}
        expect(assigns(:report)).to_not be_valid
        expect(assigns(:report).errors).to include(:account_id)
        # expect(assigns(:report)).to have(1).error_on(:account_id)
      end
      it "renders the new template" do
        post :create, params: {report: {account_id: ""}}
        expect(response).to render_template :new
      end
    end
  end

end
