require 'rails_helper'

describe InvoicePolicy do

  subject { InvoicePolicy }

  before(:each) do
    @user = double('user')
  end

  context "with active account" do
    before do
      allow(@user).to receive_message_chain(:account, :active?).and_return true
    end

    permissions :index? do
      it "allows access" do
        expect(subject).to permit(@user, Invoice.new)
      end
    end
    permissions :show? do
      it "allows access" do
        expect(subject).to permit(@user, Invoice.new)
      end
    end
    permissions :create? do
      it "allows access" do
        expect(subject).to permit(@user, Invoice.new)
      end
    end
    permissions :new? do
      it "allows access" do
        expect(subject).to permit(@user, Invoice.new)
      end
    end
    permissions :update? do
      it "allows access" do
        expect(subject).to permit(@user, Invoice.new)
      end
    end
    permissions :edit? do
      it "allows access" do
        expect(subject).to permit(@user, Invoice.new)
      end
    end
    permissions :destroy? do
      it "allows access" do
        expect(subject).to permit(@user, Invoice.new)
      end
    end
  end

  context "with inactive account" do
    before do
      allow(@user).to receive_message_chain(:account, :active?).and_return false
    end

    permissions :index? do
      it "denies access" do
        expect(subject).to_not permit(@user, Invoice.new)
      end
    end
    permissions :show? do
      it "denies access" do
        expect(subject).to_not permit(@user, Invoice.new)
      end
    end
    permissions :create? do
      it "denies access" do
        expect(subject).to_not permit(@user, Invoice.new)
      end
    end
    permissions :new? do
      it "denies access" do
        expect(subject).to_not permit(@user, Invoice.new)
      end
    end
    permissions :update? do
      it "denies access" do
        expect(subject).to_not permit(@user, Invoice.new)
      end
    end
    permissions :edit? do
      it "denies access" do
        expect(subject).to_not permit(@user, Invoice.new)
      end
    end
    permissions :destroy? do
      it "denies access" do
        expect(subject).to_not permit(@user, Invoice.new)
      end
    end
  end
end