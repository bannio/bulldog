require 'rails_helper'

describe WelcomeController do

  describe "GET 'index'" do
    login_user_with_account_state("paid")

    it "returns http success" do
      get 'index'
      expect(response).to be_successful
    end
  end

  describe "with trialing account" do

    login_user_with_account_state("trialing")

    it "continues to index when in date" do
      @account.trial_end = Time.now + 1.day
      get 'index'
      expect(response).to be_successful
    end
  end

  describe "with expired trial" do

    login_user_with_expired_account_state("trialing")

    it "sets account to expired" do
      get 'index'
      expect(response).to redirect_to(new_card_account_path(@account))
    end

    it "sets the account state to expired" do
      get 'index'
      expect(@account.reload.expired?).to be true
    end
  end

  describe "with active account (trial ended)" do

    login_user_with_expired_account_state("paid")

    it "lets them in" do
      get 'index'
      expect(response).to be_successful
    end

    it "leaves the account as paid" do
      get 'index'
      expect(@account.reload.paid?).to be true
    end
  end

  describe "with closed account" do

    login_user_with_expired_account_state("closed")

    it "routes to the change plan option" do
      get 'index'
      expect(response).to redirect_to(edit_account_path(@account))
    end

    it "leaves the account as closed" do
      get 'index'
      expect(@account.reload.closed?).to be true
    end
  end

end
