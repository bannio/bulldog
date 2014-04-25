require 'spec_helper'

describe SettingsController do

  login_user
  create_account
  create_setting

  describe "GET 'show'" do
    it "returns http success" do
      get :show, id: @setting
      response.should be_success
    end
  end

  describe "GET 'edit'" do
    it "returns http success" do
      get :edit, id: @setting
      response.should be_success
    end
  end

  describe "PATCH 'update'" do
    it "returns http success" do
      get :update, id: @setting, setting: attributes_for(:setting).merge(account_id: @account.id)
      response.should redirect_to setting_path(@setting)
    end
  end

end
