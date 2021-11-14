require 'rails_helper'

RSpec.describe ChoreListsHelper, type: :helper do
  describe 'the add chore widget helper' do
    it 'returns true for owners' do
      user = User.new(role: 'owner')
      allow(controller).to receive(:current_user).and_return(user)

      expect(helper.show_add_chore_widget?).to eq(true)
    end

    it 'returns false for viewers' do
      user = User.new(role: 'viewer')
      allow(controller).to receive(:current_user).and_return(user)

      expect(helper.show_add_chore_widget?).to eq(false)
    end
  end
end
