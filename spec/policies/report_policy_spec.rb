require 'rails_helper'

describe ReportPolicy do

  subject { ReportPolicy }

  before(:each) do
    @user = double('user')
  end

  context "active account" do
    before do
      allow(@user).to receive_message_chain(:account, :active?).and_return true
    end

    permissions :create? do
      it "allows access if account is active" do
        expect(subject).to permit(@user, Report.new)
      end
    end
    permissions :new? do
      it "allows access if account is active" do
        expect(subject).to permit(@user, Report.new)
      end
    end
  end

  context "inactive account" do
    before do
      allow(@user).to receive_message_chain(:account, :active?).and_return false
    end

    permissions :create? do
      it "denies access if account not active" do
        expect(subject).to_not permit(@user, Report.new)
      end
    end
    permissions :new? do
      it "denies access if account not active" do
        expect(subject).to_not permit(@user, Report.new)
      end
    end
  end
end