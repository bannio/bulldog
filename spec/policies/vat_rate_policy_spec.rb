require 'spec_helper'

describe VatRatePolicy do

  subject { VatRatePolicy }

  before(:each) do
    @user = double('user')
    # @account = double('account')
    # @another_account = double('account')
    # @plan = double('plan')
    # @account.stub('plan').and_return(@plan)
    # @current_user.stub('account').and_return(@account)
  end
  
  permissions :index? do
    it "denies access if plan does not include VAT" do
      @user.stub_chain(:account, :business?).and_return false
      expect(subject).to_not permit(@user, VatRate.new)
    end

    it "allows if plan does include VAT" do
      @user.stub_chain(:account, :business?).and_return true
      expect(subject).to permit(@user, VatRate.new)
    end
  end

  permissions :create? do
    it "denies access if plan does not include VAT" do
      @user.stub_chain(:account, :business?).and_return false
      expect(subject).to_not permit(@user, VatRate.new)
    end

    it "allows if plan does include VAT" do
      @user.stub_chain(:account, :business?).and_return true
      expect(subject).to permit(@user, VatRate.new)
    end
  end

  permissions :update? do
    it "denies access if plan does not include VAT" do
      @user.stub_chain(:account, :business?).and_return false
      expect(subject).to_not permit(@user, VatRate.new)
    end

    it "allows if plan does include VAT" do
      @user.stub_chain(:account, :business?).and_return true
      expect(subject).to permit(@user, VatRate.new)
    end
  end

  permissions :destroy? do
    it "denies access if plan does not include VAT" do
      @user.stub_chain(:account, :business?).and_return false
      expect(subject).to_not permit(@user, VatRate.new)
    end

    it "allows if plan does include VAT" do
      @user.stub_chain(:account, :business?).and_return true
      expect(subject).to permit(@user, VatRate.new)
    end
  end

end