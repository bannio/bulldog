require 'rails_helper'

describe PlansController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
    it "assigns all plans as @plans" do
      plan = FactoryGirl.create(:plan)
      get 'index'
      expect(assigns(:plans)).to eq [plan]
    end
  end

end
