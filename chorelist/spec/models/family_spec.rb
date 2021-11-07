require 'rails_helper'

RSpec.describe Family, type: :model do
  let(:family) { create(:family) }
  let(:chore_list_for_family) { create(:chore_list, family: family) }

  it 'has a chore list collection' do
    family = Family.new

    expect(family.chore_lists.size).to be_zero
  end

  it 'gets chore lists for the family' do
    chore_list_for_family

    expect(family.chore_lists.size).to eq(1)
    expect(family.chore_lists.first).to eq(chore_list_for_family)
  end
end
