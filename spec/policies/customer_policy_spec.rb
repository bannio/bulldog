require 'rails_helper'

describe CustomerPolicy do

  subject { CustomerPolicy }

  before(:each) do
    @user = double('user')
  end

  context "active account" do
    before do
      allow(@user).to receive_message_chain(:account, :active?).and_return true
    end

    permissions :index? do
      it "allows access if account is active" do
        expect(subject).to permit(@user, Customer.new)
      end
    end
    permissions :show? do
      it "allows access if account is active" do
        expect(subject).to permit(@user, Customer.new)
      end
    end
    permissions :create? do
      it "allows access if account is active" do
        expect(subject).to permit(@user, Customer.new)
      end
    end
    permissions :new? do
      it "allows access if account is active" do
        expect(subject).to permit(@user, Customer.new)
      end
    end
    permissions :update? do
      it "allows access if account is active" do
        expect(subject).to permit(@user, Customer.new)
      end
    end
    permissions :edit? do
      it "allows access if account is active" do
        expect(subject).to permit(@user, Customer.new)
      end
    end
    permissions :destroy? do
      it "allows access if account is active" do
        expect(subject).to permit(@user, Customer.new)
      end
    end
  end

  context "inactive account" do
    before do
      allow(@user).to receive_message_chain(:account, :active?).and_return false
    end

    permissions :index? do
      it "denies access if account not active" do
        expect(subject).to_not permit(@user, Customer.new)
      end
    end
    permissions :show? do
      it "denies access if account not active" do
        expect(subject).to_not permit(@user, Customer.new)
      end
    end
    permissions :create? do
      it "denies access if account not active" do
        expect(subject).to_not permit(@user, Customer.new)
      end
    end
    permissions :new? do
      it "denies access if account not active" do
        expect(subject).to_not permit(@user, Customer.new)
      end
    end
    permissions :update? do
      it "denies access if account not active" do
        expect(subject).to_not permit(@user, Customer.new)
      end
    end
    permissions :edit? do
      it "denies access if account not active" do
        expect(subject).to_not permit(@user, Customer.new)
      end
    end
    permissions :destroy? do
      it "denies access if account not active" do
        expect(subject).to_not permit(@user, Customer.new)
      end
    end
  end
end