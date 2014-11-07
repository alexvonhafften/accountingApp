class GroupsUsers < ActiveRecord::Migration
  def change
    create_table :groups_users do |t|
      t.belongs_to :user
      t.belongs_to :group
    end
  end
end
