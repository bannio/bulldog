require 'rails_helper'

describe CreateAccount do

  let(:params){ {name: "test", email: "test@example.com", plan_id: "1", mail_list: "1"} }
  # let(:customer){ double('customer', id: 'cus_123')}
  let(:user){ User.new }

  it "returns an account" do
    allow(CreateCustomer).to receive(:call)
    allow(User).to receive(:create).and_return(user)
    allow(AddToMailList).to receive(:call).and_return(true)
    account = CreateAccount.call(params)
    expect(account.valid?).to be true
    expect(account.persisted?).to be true
  end

  it "transitions state to trialing" do
    allow(CreateCustomer).to receive(:call)
    allow(User).to receive(:create).and_return(user)
    allow(AddToMailList).to receive(:call).and_return(true)
    account = CreateAccount.call(params)
    expect(account.trialing?).to be true
  end

  it "returns an account with errors when missing params" do
    bad_params = {}
    account = CreateAccount.call(bad_params)
    expect(account).to be
    expect(account.valid?).to be false
    expect(account.persisted?).to be false
    expect(account.errors).to_not be_empty
  end

  it "returns an account with errors when email in use" do
    FactoryBot.create(:user, email: params[:email])
    allow(CreateCustomer).to receive(:call)
    allow(User).to receive(:create).and_return(user)
    allow(AddToMailList).to receive(:call).and_return(true)
    account = CreateAccount.call(params)
    expect(account.persisted?).to be false
    expect(account.errors).to_not be_empty
    expect(account.errors[:email]).to include("The email #{params[:email]} is already in use")
  end

  it "no longer returns an account with errors when Stripe fails" do
    allow(Stripe::Customer).to receive(:create).and_raise(Stripe::StripeError, "Stripe error")
    allow(User).to receive(:create).and_return(user)
    allow(AddToMailList).to receive(:call).and_return(true)
    account = CreateAccount.call(params)
    expect(account.persisted?).to be true
    expect(account.errors[:base]).not_to include("Stripe error")
  end
end