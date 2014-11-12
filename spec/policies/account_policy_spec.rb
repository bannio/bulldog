require 'rails_helper'

describe AccountPolicy do

  subject { AccountPolicy }

  before(:each) do
    @user = double('user')
  end

  context "with active account" do
    before do
      allow(@user).to receive_message_chain(:account, :active?).and_return true
    end

    permissions :show? do
      it "allows access" do
        expect(subject).to permit(@user, Account.new)
      end
    end
    permissions :create? do
      it "allows access" do
        expect(subject).to permit(@user, Account.new)
      end
    end
    permissions :new? do
      it "allows access" do
        expect(subject).to permit(@user, Account.new)
      end
    end
    permissions :update? do
      it "allows access" do
        expect(subject).to permit(@user, Account.new)
      end
    end
    permissions :edit? do
      it "allows access" do
        expect(subject).to permit(@user, Account.new)
      end
    end
    permissions :cancel? do
      it "allows access" do
        allow(@user).to receive_message_chain(:account, :paying?).and_return true
        expect(subject).to permit(@user, Account.new)
      end
    end
  end

  context "with inactive account" do
    before do
      allow(@user).to receive_message_chain(:account, :active?).and_return false
    end

    permissions :show? do
      it "allows access" do
        expect(subject).to permit(@user, Account.new)
      end
    end
    permissions :create? do
      it "allows access" do
        expect(subject).to permit(@user, Account.new)
      end
    end
    permissions :new? do
      it "allows access" do
        expect(subject).to permit(@user, Account.new)
      end
    end
    permissions :update? do
      it "allows access" do
        expect(subject).to permit(@user, Account.new)
      end
    end
    permissions :edit? do
      it "allows access" do
        expect(subject).to permit(@user, Account.new)
      end
    end
    permissions :cancel? do
      it "denies access" do
        allow(@user).to receive_message_chain(:account, :paying?).and_return false
        expect(subject).to_not permit(@user, Account.new)
      end
      it "allows if paying" do
        allow(@user).to receive_message_chain(:account, :paying?).and_return true
        expect(subject).to permit(@user, Account.new)
      end
    end
  end
end