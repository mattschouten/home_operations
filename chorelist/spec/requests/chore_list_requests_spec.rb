require 'rails_helper'

RSpec.describe 'Chore Lists', type: :request do
  describe 'logged-out users' do
    it 'should be redirected to login when they try to list chore lists' do
      get chore_lists_path
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'should be redirected to login when they try to get a chore list' do
      get chore_list_path(id: 1)
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe 'logged-in users' do
    let(:user) { create(:user) }

    it 'should be abel to list their chore lists' do
      sign_in user
      get chore_lists_path
      expect(response).to have_http_status(200)
    end
  end
end
