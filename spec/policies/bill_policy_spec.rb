require 'rails_helper'

describe BillPolicy do

  subject { BillPolicy }

  before(:each) do
    @user = double('user')
    # @account = double('account')
    # @another_account = double('account')
    # @plan = double('plan')
    # @account.stub('plan').and_return(@plan)
    # @current_user.stub('account').and_return(@account)
  end
  
  permissions :index? do
    it "denies access if account not active" do
      allow(@user).to receive_message_chain(:account, :active?).and_return false
      expect(subject).to_not permit(@user, Bill.new)
    end

    it "allows access if account is active" do
      allow(@user).to receive_message_chain(:account, :active?).and_return true
      expect(subject).to permit(@user, Bill.new)
    end
  end

  permissions :create? do
    it "denies access if account not active" do
      allow(@user).to receive_message_chain(:account, :active?).and_return false
      expect(subject).to_not permit(@user, Bill.new)
    end

    it "allows access if account is active" do
      allow(@user).to receive_message_chain(:account, :active?).and_return true
      expect(subject).to permit(@user, Bill.new)
    end
  end

  permissions :update? do
    it "denies access if account not active" do
      allow(@user).to receive_message_chain(:account, :active?).and_return false
      expect(subject).to_not permit(@user, Bill.new)
    end

    it "allows access if account is active" do
      allow(@user).to receive_message_chain(:account, :active?).and_return true
      expect(subject).to permit(@user, Bill.new)
    end
  end

  permissions :destroy? do
    it "denies access if account not active" do
      allow(@user).to receive_message_chain(:account, :active?).and_return false
      expect(subject).to_not permit(@user, Bill.new)
    end

    it "allows access if account is active" do
      allow(@user).to receive_message_chain(:account, :active?).and_return true
      expect(subject).to permit(@user, Bill.new)
    end
  end
end