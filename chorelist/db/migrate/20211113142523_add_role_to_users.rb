class AddRoleToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :role, :string, null: false, default: 'owner'
    add_check_constraint :users, "role in ('owner', 'viewer')", name: 'role_check'
  end
end
