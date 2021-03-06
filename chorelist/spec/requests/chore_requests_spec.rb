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
    context "accessing their family's chores" do
      let(:family) { create(:family) }
      let(:owner) { create(:user, family: family, role: "owner") }
      let(:viewer) { create(:user, family: family, role: "viewer") }
      let(:chore_list) { create(:chore_list, family: family) }

      context 'as owner' do
        it 'can create a chore' do
          chore_params = {
            chore: {
              name: 'Try not falling in a well', assigned_to: 'Timmy', is_done: false
            }
          }

          sign_in owner

          expect {
            post chore_list_chores_path(chore_list_id: chore_list.id, params: chore_params)
          }.to change(Chore, :count).by(1)

          expect(response).to redirect_to(chore_list_path(chore_list))
        end

        it 'can update whether a chore is done' do
          chore = create(:chore, chore_list: chore_list)

          sign_in owner
          new_attributes = {
            completed: { chore.id => true }
          }
          patch chore_list_chore_path(chore_list_id: chore_list.id, id: chore.id),
                params: new_attributes

          expect(response).to redirect_to(chore_list_path(chore_list))
          updated = Chore.find(chore.id)
          expect(updated.is_done).to be true
        end

        it 'redirects to the original URL if set' do
          chore = create(:chore, chore_list: chore_list)

          sign_in owner
          new_attributes = {
            completed: { chore.id => true }
          }

          get today_path
          patch chore_list_chore_path(chore_list_id: chore_list.id, id: chore.id),
                params: new_attributes

          expect(response).to redirect_to(today_path)
        end

        it 'redirects to the chore list path if original URL is not set' do
          chore = create(:chore, chore_list: chore_list)

          sign_in owner
          new_attributes = {
            completed: { chore.id => true }
          }


          # DO NOT get today_path (or any other path) so the previous URL is not set in the session
          patch chore_list_chore_path(chore_list_id: chore_list.id, id: chore.id),
                params: new_attributes

          expect(response).to redirect_to(chore_list_path(chore_list))
        end
      end

      context 'as viewer' do
        it 'cannot create a chore' do
          chore_params = {
            chore: {
              name: 'Try not falling in a well', assigned_to: 'Timmy', is_done: false
            }
          }

          sign_in viewer
          expect {
            post chore_list_chores_path(chore_list_id: chore_list.id, params: chore_params)
          }.to_not change(Chore, :count)

          expect(response).to redirect_to(chore_list_path(chore_list))
        end

        it 'can update whether a chore is done' do
          chore = create(:chore, chore_list: chore_list)

          sign_in viewer
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
    end

    context "accessing another family's chores" do
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
