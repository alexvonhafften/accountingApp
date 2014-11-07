class Initial < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_hash
    end
    create_table :groups do |t|
      t.string :name
    end
    create_table :payments do |t|
      t.string :name
      t.string :type
      t.datetime :due
      t.boolean :done
    end
  end
end
