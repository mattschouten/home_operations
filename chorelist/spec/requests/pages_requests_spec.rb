require 'rails_helper'

RSpec.describe 'Public Pages', type: :request do
  context 'logged-out users' do
    it 'can access the index page' do
      get root_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'logged-in users' do
    let(:user) { create(:user) }

    it 'can access the index page' do
      sign_in user
      get root_path
      expect(response).to have_http_status(200)
    end
  end
end
