require 'rails_helper'

RSpec.describe "chore_lists/show", type: :view do
  before(:each) do
    @chore_list = ChoreList.new(id: 100, date: Date.today)
    @chores_by_person = {}
  end

  context 'for owners' do
    before do
      allow(view).to receive(:show_add_chore_widget?).and_return(true)
    end

    it 'includes a form to add new chores' do
      render

      expect(rendered).to match(/<div id="addChore"/)
      expect(rendered).to match(/label for.+>Chore</)
      expect(rendered).to match(/label for.+>Assigned to</)
      expect(rendered).to match(/"Create Chore"/)
    end

    it 'includes a button to carry over until tomorrow' do
      render

      expect(rendered).to match(/<div id="carryOver"/)
      expect(rendered).to match(/Carry over to tomorrow/)
    end
  end

  context 'for viewers' do
    before do
      allow(view).to receive(:show_add_chore_widget?).and_return(false)
    end
    it 'does not include a form to add new chores' do
      render

      expect(rendered).to_not match(/<div id="addChore"/)
      expect(rendered).to_not match(/label for.+>Chore</)
      expect(rendered).to_not match(/label for.+>Assigned to</)
      expect(rendered).to_not match(/"Create Chore"/)
    end

    it 'does not include a button to carry over until tomorrow' do
      render

      expect(rendered).to_not match(/<div id="carryOver"/)
      expect(rendered).to_not match(/Carry over to tomorrow/)
    end
  end
end
