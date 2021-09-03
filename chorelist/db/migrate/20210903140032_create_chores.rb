class CreateChores < ActiveRecord::Migration[6.1]
  def change
    create_table :chores do |t|
      t.string :name
      t.string :assigned_to
      t.boolean :is_done
      t.references :chore_list, null: false, foreign_key: true

      t.timestamps
    end
  end
end
