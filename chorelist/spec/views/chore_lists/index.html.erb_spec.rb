require 'rails_helper'

RSpec.describe "chore_lists/index", type: :view do
  it 'should work even if there are no chore lists' do
    render

    expect(rendered).to match(/Chore Lists/)
  end
end
