require 'rails_helper'

describe Category do
  it 'is invalid without a name' do
    category = FactoryBot.build(:category, name: "")
    expect(category).to_not be_valid
  end
  it 'is invalid without a name on update' do
    category = FactoryBot.create(:category)
    expect(category.update(name: "")).to be_falsey
  end
  it 'knows the sum of its bills' do
    @category = FactoryBot.create(:category)
    bill = FactoryBot.create(:bill, category_id: @category.id, amount: 10 )
    bill2 = FactoryBot.create(:bill, category_id: @category.id, amount: 10 )
    bill3 = FactoryBot.create(:bill, amount: 10 )

    expect(@category.total).to eq 20
  end

  it "requires a unique name within account" do
    category = create(:category, name: "duplicate")
    expect(build(:category, name: "duplicate")).to_not be_valid
    expect(build(:category, name: "duplicate", account_id: 99)).to be_valid
  end

  it "is not case sensitive when checking uniqueness" do
    category = create(:category, name: "Duplicate")
    expect(build(:category, name: "duplicate")).to_not be_valid
  end

  it "checks for bills before destroying" do
    @category = FactoryBot.create(:category)
    bill = FactoryBot.create(:bill, category_id: @category.id, amount: 10 )
    expect{
      @category.destroy
    }.to_not change(Category, :count)

  end

  it "can reassign its bills to another" do
    category = FactoryBot.create(:category, name: "one")
    category2 = FactoryBot.create(:category, name: "two")
    bill = FactoryBot.create(:bill, category_id: category.id )
    bill2 = FactoryBot.create(:bill, category_id: category2.id )
    category.reassign_bills_to("two")
    expect(bill.reload.category_id).to eq category2.id
  end
end
