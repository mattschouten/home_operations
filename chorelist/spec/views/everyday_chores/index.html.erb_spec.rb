require 'rails_helper'

RSpec.describe "everyday_chores/index", type: :view do
  it 'should work even if there are no everyday chores yet' do
    render

    expect(rendered).to match(/Everyday Chore/)
  end
end
