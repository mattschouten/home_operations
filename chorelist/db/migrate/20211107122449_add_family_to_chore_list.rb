class AddFamilyToChoreList < ActiveRecord::Migration[6.1]
  def change
    add_reference :chore_lists, :family, null: false, foreign_key: true
  end
end
