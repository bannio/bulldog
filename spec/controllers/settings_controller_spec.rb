require 'spec_helper'

describe SettingsController do

  login_user

  before(:each) do
    Rails.logger.info "The user is: #{@user.id}"
    def current_user
      @user
    end
    Rails.logger.info "The current_user is: #{current_user.id}"
  end

  describe "GET 'show'" do
    it "returns http success" do
      Rails.logger.info "The current_user is: #{current_user.id}"
      get :show, id: @account.setting
      response.should be_success
    end
  end

  describe "GET 'edit'" do
    it "returns http success" do
      Rails.logger.info "The current_user is: #{current_user.id}"
      get :edit, id: @account.setting
      response.should be_success
    end
  end

  describe "PATCH 'update'" do
    it "returns http success" do
      Rails.logger.info "The current_user is: #{current_user.id}"
      get :update, id: @account.setting, setting: attributes_for(:setting).merge(account_id: @account.id)
      response.should redirect_to setting_path(@account.setting)
    end
  end

end
