class AddFamilyToChoreList < ActiveRecord::Migration[6.1]
  def up
    # Add a family record if one doesn't exist
    default_family = Family.first || Family.create!(name: 'Default Family')

    # add the reference with a default value to do the migration
    add_reference :chore_lists, :family, null: false, foreign_key: true, default: default_family.id

    # now remove the default
    change_column_default :chore_lists, :family_id, nil
  end

  def down
    remove_reference :chore_lists, :family, foreign_key: true
  end
end
