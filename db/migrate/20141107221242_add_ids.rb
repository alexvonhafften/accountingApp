class AddIds < ActiveRecord::Migration
  def change
    change_table :payments do |t|
      t.integer :user_id
      t.integer :group_id
    end
  end
end
