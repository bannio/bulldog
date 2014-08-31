require 'rails_helper'

describe CategoryPolicy do

  subject { CategoryPolicy }

  before(:each) do
    @user = double('user')
  end

  context "active account" do
    before do
      allow(@user).to receive_message_chain(:account, :active?).and_return true
    end

    permissions :index? do
      it "allows access if account is active" do
        expect(subject).to permit(@user, Category.new)
      end
    end
    permissions :update? do
      it "allows access if account is active" do
        expect(subject).to permit(@user, Category.new)
      end
    end
    permissions :edit? do
      it "allows access if account is active" do
        expect(subject).to permit(@user, Category.new)
      end
    end
  end

  context "inactive account" do
    before do
      allow(@user).to receive_message_chain(:account, :active?).and_return false
    end

    permissions :index? do
      it "denies access if account not active" do
        expect(subject).to_not permit(@user, Category.new)
      end
    end
    permissions :update? do
      it "denies access if account not active" do
        expect(subject).to_not permit(@user, Category.new)
      end
    end
    permissions :edit? do
      it "denies access if account not active" do
        expect(subject).to_not permit(@user, Category.new)
      end
    end
  end
end