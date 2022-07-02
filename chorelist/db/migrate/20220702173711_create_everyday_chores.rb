class CreateEverydayChores < ActiveRecord::Migration[6.1]
  def change
    create_table :everyday_chores do |t|
      t.string :name
      t.string :assigned_to
      t.references :family, null: false, foreign_key: true

      t.timestamps
    end
  end
end
