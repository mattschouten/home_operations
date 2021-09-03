class CreateChoreLists < ActiveRecord::Migration[6.1]
  def change
    create_table :chore_lists do |t|
      t.date :date

      t.timestamps
    end
  end
end
