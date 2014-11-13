class DeleteUsersGroups < ActiveRecord::Migration
  def change
    drop_table :users_groups
  end
end
