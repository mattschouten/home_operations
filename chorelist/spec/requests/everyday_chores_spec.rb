require 'rails_helper'

RSpec.describe "EverydayChores", type: :request do
  describe 'for logged-out users' do
    it 'should be redirected to login when they try to list everyday chores' do
      get everyday_chores_path
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'should be redirected to login when they try to get an everyday chore' do
      get everyday_chores_path(id: 1)
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe 'for logged-in users' do
    let(:owner) { create(:user, family: family) }
    let(:viewer) { create(:user, family: family, role: 'viewer') }
    let(:family) { create(:family) }

    context "accessing their family's own everyday chores" do
      let(:everyday_chore) { create(:everyday_chore, family: family, name: 'Save Timmy', assigned_to: 'Lassie') }
      let(:valid_params) do
        {
          everyday_chore: {
            name: 'Ask "What is it, girl?"',
            assigned_to: 'Dad'
          }
        }
      end

      let(:modify_params) do
        {
          everyday_chore: {
            name: 'Ignore Timmy',
            assigned_to: 'Mom'
          }
        }
      end

      it 'can see their everday chores as owner' do
        everyday_chore
        sign_in owner

        get everyday_chores_path

        expect(response).to have_http_status(200)
        expect(response.body).to include('Save Timmy')
      end

      it 'can see their everday chores as viewer' do
        everyday_chore
        sign_in viewer

        get everyday_chores_path

        expect(response).to have_http_status(200)
        expect(response.body).to include('Save Timmy')
      end

      it 'can show an everyday chore as an owner' do
        everyday_chore
        sign_in owner

        get everyday_chore_path(id: everyday_chore.id)

        expect(response).to have_http_status(200)
        expect(response.body).to include('Save Timmy')
      end

      it 'can NOT show an everyday chore as a viewer' do
        everyday_chore
        sign_in viewer

        get everyday_chore_path(id: everyday_chore.id)

        expect(response).to_not have_http_status(200)
        expect(response.body).to_not include('Save Timmy')
      end

      it 'can create an everyday chore as an owner' do
        everyday_chore
        sign_in owner

        expect {
          post everyday_chores_path(valid_params)
        }.to change(EverydayChore, :count).by(1)

        expect(response).to redirect_to(everyday_chore_path(id: EverydayChore.last.id))
      end

      it 'can NOT create an everyday chore as a viewer' do
        everyday_chore
        sign_in viewer

        expect {
          post everyday_chores_path(valid_params)
        }.to change(EverydayChore, :count).by(0)

        expect(response).to have_http_status(:forbidden)
      end

      it 'can modify an everyday chore as an owner' do
        everyday_chore
        sign_in owner

        put everyday_chore_path(id: everyday_chore.id, params: modify_params)

        expect(response).to redirect_to(everyday_chore_path(id: everyday_chore.id))
        expect(EverydayChore.last.assigned_to).to eq('Mom')
      end

      it 'can NOT modify an everyday chore as a viewer' do
        everyday_chore
        sign_in viewer

        put everyday_chore_path(id: everyday_chore.id, params: modify_params)

        expect(response).to have_http_status(:forbidden) # Should be the list?
      end

      it 'can delete an everyday chore as an owner' do
        everyday_chore
        sign_in owner

        expect {
          delete everyday_chore_path(id: everyday_chore.id)
        }.to change(EverydayChore, :count).by(-1)

        expect(response).to redirect_to(everyday_chores_path)
      end

      it 'can NOT delete an everyday chore as a viewer' do
        everyday_chore
        sign_in viewer

        delete everyday_chore_path(id: everyday_chore.id)

        expect(response).to have_http_status(:forbidden)
      end
    end

    context "accessing another family's everyday chores" do
      let (:user) { create(:user, family: family)}
      let (:another_family) { create(:family) }
      let (:not_my_everyday_chore) { create(:everyday_chore, family: another_family, name: 'Sweep', assigned_to: 'Bob') }

      it 'will not show lists that belong to another family' do
        not_my_everyday_chore
        sign_in user

        get everyday_chores_path

        expect(response).to have_http_status(200)
        expect(response.body).to_not include('Sweep')
      end

      it 'will not show an everyday chore that belongs to another family' do
        not_my_everyday_chore
        sign_in user

        get everyday_chore_path(id: not_my_everyday_chore.id)

        expect(response).to have_http_status(:forbidden)
        expect(response.body).to_not include('Sweep')
      end

      it 'will not update an everyday chore that belongs to another family' do
        not_my_everyday_chore
        sign_in user

        expect {
          put everyday_chore_path(id: not_my_everyday_chore.id, params: {})
        }.to change(EverydayChore, :count).by(0)

        expect(response).to have_http_status(:forbidden)
      end

      it 'will not delete an everyday chore that belongs to another family' do
        not_my_everyday_chore
        sign_in user

        expect {
          delete everyday_chore_path(id: not_my_everyday_chore.id)
        }.to change(EverydayChore, :count).by(0)

        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
