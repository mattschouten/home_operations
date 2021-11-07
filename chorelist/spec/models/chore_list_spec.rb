require 'rails_helper'

RSpec.describe ChoreList, type: :model do
  it 'must belong to a family' do
    chore_list = ChoreList.new(date: Date.today)
    chore_list.validate

    expect(chore_list).to_not be_valid
    expect(chore_list.errors[:family]).to include("must exist")
  end

  it 'belongs to a family' do
    chore_list = ChoreList.new(date: Date.today)
    family = create(:family)
    chore_list.family = family
    chore_list.validate

    expect(chore_list).to be_valid
  end
end
