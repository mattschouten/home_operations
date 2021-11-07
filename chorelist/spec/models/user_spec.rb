require 'rails_helper'

RSpec.describe User, type: :model do
  let(:family) { create(:family) }

  describe 'associations with a family' do
    it 'can be associated with a family' do
      user = User.new(email: 'me@example.com', password: 'secret!@!!')
      expect(user.family).to be_nil

      f = Family.new(name: "This is a family")
      user.family = f
      expect(user.family).to_not be_nil
    end
  end
end
