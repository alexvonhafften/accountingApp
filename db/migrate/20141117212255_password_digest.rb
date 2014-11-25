class PasswordDigest < ActiveRecord::Migration
  def change
    remove_column :users, :password_hash
    change_table :users do |t|
      t.string :password_digest
    end
  end
end
