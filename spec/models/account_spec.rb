require 'spec_helper'

describe Account do
  it "validates presence of user_id" do
    expect(Account.new(user_id: "")).to_not be_valid
  end
  it "validates presence of name" do
    expect(Account.new(name: "")).to_not be_valid
  end

  # it "knows the current account id" do
  #   expect(Account).to respond_to(:current_id)
  # end

  # it "can set the current account id" do
  #   expect(Account).to respond_to(:current_id=)
  # end
end
