require 'rails_helper'

RSpec.describe "_choreblock", type: :view do
  before(:each) do
    @chore_list = ChoreList.new(id: 100, date: Date.today)
  end

  it 'does not add the COMPLETED class to the chore list if not everything is completed' do
    chores_by_person = {
      'Timmy' => [Chore.new(name: 'Stay out of the old barn', assigned_to: 'Timmy', is_done: false)]
    }

    render partial: 'chore_lists/choreblock.html.erb', locals: {
      chores_by_person: chores_by_person,
      assigned_to: 'Timmy'
    }

    expect(rendered).to_not match(/div.*completed/)
  end

  it 'adds the COMPLETED class to the chore list if everything is completed' do
    chores_by_person = {
      'Lassie' => [Chore.new(name: 'Go for help', assigned_to: 'Lassie', is_done: true)]
    }

    render partial: 'chore_lists/choreblock.html.erb', locals: {
      chores_by_person: chores_by_person,
      assigned_to: 'Lassie'
    }

    expect(rendered).to match(/<div.*class="choreblock completed"/)
  end
end
