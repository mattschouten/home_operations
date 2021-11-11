require 'rails_helper'

RSpec.describe 'Chores', type: :request do
  describe 'logged-out users' do
    it 'should be redirected to login instead of creating chores' do
      post chore_list_chores_path(chore_list_id: 1)
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'should be redirected to login instead of updating chores' do
      put chore_list_chore_path(chore_list_id: 1, id: 1)
      expect(response).to redirect_to(new_user_session_path)

      patch chore_list_chore_path(chore_list_id: 1, id: 1)
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe 'logged-in users' do
    context 'accessing their own chores' do
      let(:family) { create(:family) }
      let(:user) { create(:user, family: family) }
      let(:chore_list) { create(:chore_list, family: family) }

      it 'can create a chore' do
        chore_params = {
          chore: {
            name: 'Try not falling in a well', assigned_to: 'Timmy', is_done: false
          }
        }

        sign_in user
        post chore_list_chores_path(chore_list_id: chore_list.id, params: chore_params)

        expect(response).to redirect_to(chore_list_path(chore_list))
      end

      it 'can update whether a chore is done' do
        chore = create(:chore, chore_list: chore_list)

        sign_in user
        new_attributes = {
          completed: { chore.id => true }
        }
        patch chore_list_chore_path(chore_list_id: chore_list.id, id: chore.id),
              params: new_attributes

        expect(response).to redirect_to(chore_list_path(chore_list))
        updated = Chore.find(chore.id)
        expect(updated.is_done).to be true
      end
    end

    context 'for chores that are not mine' do
      let(:another_users_family) { create(:family) }
      let(:this_users_family) { create(:family) }
      let(:user) { create(:user, family: this_users_family) }
      let(:chore_list) { create(:chore_list, family: another_users_family) }

      it 'cannot create a chore' do
        chore_params = {
          chore: {
            name: 'Try not falling in a well', assigned_to: 'Timmy', is_done: false
          }
        }

        sign_in user
        post chore_list_chores_path(chore_list_id: chore_list.id, params: chore_params)

        expect(response.code).to eq('403')
      end

      it 'cannot update whether a chore is done' do
        chore = create(:chore, chore_list: chore_list, is_done: false)

        sign_in user
        new_attributes = {
          completed: { chore.id => true }
        }
        patch chore_list_chore_path(chore_list_id: chore_list.id, id: chore.id),
              params: new_attributes

        expect(response.code).to eq('403')
        updated = Chore.find(chore.id)
        expect(updated.is_done).to be false
      end
    end
  end
end
