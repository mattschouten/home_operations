require 'rails_helper'

RSpec.describe Family, type: :model do
  let(:family) { create(:family) }
  let(:chore_list_for_family) { create(:chore_list, family: family) }

  it 'has a chore list collection' do
    expect(family.chore_lists.size).to be_zero
  end

  it 'gets chore lists for the family' do
    chore_list_for_family

    expect(family.chore_lists.size).to eq(1)
    expect(family.chore_lists.first).to eq(chore_list_for_family)
  end

  it 'has a collection of users associated' do
    expect(family.users.size).to be_zero

    user = create(:user)
    user.family = family
    user.save!
    family.reload
    expect(family.users.size).to eq(1)
    expect(family.users).to include(user)

    user2 = create(:user)
    user2.family = family
    user2.save!
    expect(family.users.size).to be(2)
    expect(family.users).to include(user2)
  end
end
