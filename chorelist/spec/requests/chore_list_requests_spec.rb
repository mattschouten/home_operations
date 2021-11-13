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

      it 'can get a list' do
        # add a chore to the list to give us something to check for
        create(:chore,
          chore_list: chore_list, name: 'Stay out of the well', assigned_to: 'Timmy', is_done: false
        )

        sign_in user

        get chore_list_path(id: chore_list.id)

        expect(response).to have_http_status(200)
        expect(response.body).to include('Stay out of the well')
        expect(response.body).to include('Timmy')
      end

      it 'can create a list for a given date' do
        chore_list_params = { chore_list: { date: '1954-09-12' } }
        sign_in user

        post chore_lists_path(chore_list_params)

        expect(response).to have_http_status(302)
        created_list = ChoreList.last
        expect(created_list.family).to eq(family)
        expect(created_list.date).to eq(Date.new(1954, 9, 12))
      end

      it 'can carryover a list' do
        incomplete_chore = create(:chore,
          chore_list: chore_list, name: 'Stay out of the well', assigned_to: 'Timmy', is_done: false
        )
        complete_chore = create(:chore,
          chore_list: chore_list, name: 'Rescue Timmy', assigned_to: 'Lassie', is_done: true
        )

        sign_in user

        post carryover_chore_list_path(id: chore_list.id)

        expect(response).to have_http_status(302)

        carryover_chore_list = ChoreList.last
        expect(carryover_chore_list.id).to_not eq(chore_list.id)
        expect(carryover_chore_list.family).to eq(chore_list.family)
        expect(carryover_chore_list.chores.size).to eq(1)
        expect(carryover_chore_list.chores[0]).to have_attributes(
          name: "*#{incomplete_chore.name}",
          assigned_to: incomplete_chore.assigned_to,
          is_done: incomplete_chore.is_done
        )
      end

      it 'can get the list for today' do
        create(:chore,
          chore_list: chore_list, name: 'Try not getting eaten by wolves', assigned_to: 'Timmy', is_done: false
        )

        sign_in user

        get today_path

        expect(response).to have_http_status(200)
        expect(response.body).to include('Try not getting eaten by wolves')
        expect(response.body).to include('Timmy')
      end

      it 'redirects to the list of chore lists if a list for today does not exist' do
        create(:chore_list, date: Date.new(2001, 1, 1), family: family)

        sign_in user

        get today_path

        expect(response).to have_http_status(302)
        expect(response).to redirect_to(chore_lists_path)
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

      it "cannot get another family's list" do
        # add a chore to the list to give us something to check for
        create(:chore,
          chore_list: not_my_chore_list, name: 'Stay out of the well', assigned_to: 'Timmy', is_done: false
        )

        sign_in user

        get chore_list_path(id: not_my_chore_list.id)

        expect(response).to have_http_status(403)
        expect(response.body).to_not include('Stay out of the well')
        expect(response.body).to_not include('Timmy')
      end

      it "cannot carry over another family's list" do
        incomplete_chore = create(:chore,
          chore_list: not_my_chore_list, name: 'Stay out of the well', assigned_to: 'Timmy', is_done: false
        )

        sign_in user

        expect {
          post carryover_chore_list_path(id: not_my_chore_list.id)
        }.to_not change(ChoreList, :count)

        expect(response).to have_http_status(403)
      end

      it 'only gets my own lists for today' do
        # A list for another family, a list for my family, each with a chore
        create(:chore,
          chore_list: not_my_chore_list, name: 'Go for help', assigned_to: 'Lassie', is_done: true
        )

        my_family_list = create(:chore_list, family: family)
        create(:chore,
          chore_list: my_family_list, name: 'Avoid bear traps', assigned_to: 'Timmy', is_done: false
        )

        sign_in user

        get today_path

        # We expect only my family's list to show up
        expect(response).to have_http_status(200)
        expect(response.body).to include('Avoid bear traps')
        expect(response.body).to include('Timmy')
      end

      it 'redirects to the list of chore lists if only lists for other families exist' do
        create(:chore,
          chore_list: not_my_chore_list, name: 'Lead people to Timmy', assigned_to: 'Lassie', is_done: true
        )

        sign_in user

        get today_path

        expect(response).to have_http_status(302)
        expect(response).to redirect_to(chore_lists_path)
      end
    end
  end
end
