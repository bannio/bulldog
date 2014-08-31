require 'rails_helper'

describe SupplierPolicy do

  subject { SupplierPolicy }

  before(:each) do
    @user = double('user')
  end

  context "active account" do
    before do
      allow(@user).to receive_message_chain(:account, :active?).and_return true
    end

    permissions :index? do
      it "allows access if account is active" do
        expect(subject).to permit(@user, Supplier.new)
      end
    end
    permissions :update? do
      it "allows access if account is active" do
        expect(subject).to permit(@user, Supplier.new)
      end
    end
    permissions :edit? do
      it "allows access if account is active" do
        expect(subject).to permit(@user, Supplier.new)
      end
    end
  end

  context "inactive account" do
    before do
      allow(@user).to receive_message_chain(:account, :active?).and_return false
    end

    permissions :index? do
      it "denies access if account not active" do
        expect(subject).to_not permit(@user, Supplier.new)
      end
    end
    permissions :update? do
      it "denies access if account not active" do
        expect(subject).to_not permit(@user, Supplier.new)
      end
    end
    permissions :edit? do
      it "denies access if account not active" do
        expect(subject).to_not permit(@user, Supplier.new)
      end
    end
  end
end