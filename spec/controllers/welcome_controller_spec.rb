require 'spec_helper'

describe WelcomeController do

  login_user # so authenticate_user! works and sets @user

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

end
