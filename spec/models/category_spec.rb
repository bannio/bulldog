require 'spec_helper'

describe Category do
  it 'is invalid without a name' do
    @category = FactoryGirl.build(:category, name: "")
    @category.should_not be_valid
  end

  it 'knows the sum of its bills' do
    @category = FactoryGirl.create(:category)
    bill = FactoryGirl.create(:bill, category_id: @category.id, amount: 10 )
    bill2 = FactoryGirl.create(:bill, category_id: @category.id, amount: 10 )
    bill3 = FactoryGirl.create(:bill, amount: 10 )

    @category.total.should eq 20
  end
end
