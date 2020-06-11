require 'rails_helper'

describe SettingsController do

  login_user

  def current_user
    @user
  end

  before do
    @setting = @account.setting
  end


  describe "GET 'show'" do

    it "returns http success" do
      get :show, params: {id: @setting}
      expect(response).to be_success
    end
    it "assigns the setting" do
      get :show, params: {id: @setting}
      expect(assigns(:setting)).to eq @setting
    end
  end

  describe "GET 'edit'" do
    it "returns http success" do
      get :edit, params: {id: @setting}
      expect(response).to be_success
    end
  end

  describe "PATCH 'update'" do

    it "assigns the setting" do
      get :update, params: {id: @setting, setting: attributes_for(:setting)}
      expect(assigns(:setting)).to eq @setting
    end
    it "returns http success" do
      get :update, params: {id: @setting, setting: attributes_for(:setting)}
      expect(response).to redirect_to setting_path(@setting)
    end
  end

end
