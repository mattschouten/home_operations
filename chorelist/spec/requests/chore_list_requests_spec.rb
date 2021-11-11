require 'rails_helper'

RSpec.describe 'Chore Lists', type: :request do
  describe 'for logged-out users' do
    it 'should be redirected to login when they try to list chore lists' do
      get chore_lists_path
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'should be redirected to login when they try to get a chore list' do
      get chore_list_path(id: 1)
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe 'for logged-in users' do
    let(:user) { create(:user, family: family) }
    let(:family) { create(:family) }

    it 'should be able to list their chore lists' do
      sign_in user
      get chore_lists_path
      expect(response).to have_http_status(200)
    end

    context "accessing their family's own chore lists" do
      let(:chore_list) { create(:chore_list, family: family) }

      it 'can see their lists' do
        chore_list
        sign_in user

        get chore_lists_path

        expect(response).to have_http_status(200)
        expect(response.body).to include('/chore_lists/1')
      end
    end

    context "accessing another family's chore lists" do
      let (:another_family) { create(:family) }
      let (:not_my_chore_list) { create(:chore_list, family: another_family) }

      it 'will not show lists that belong to another family' do
        not_my_chore_list
        sign_in user

        get chore_lists_path

        expect(response).to have_http_status(200)
        expect(response.body).to_not include('/chore_lists/1')
      end
    end
  end
end
