class AddFamilyToUser < ActiveRecord::Migration[6.1]
  def change
    add_reference :users, :family, null: true, foreign_key: true
  end
end
