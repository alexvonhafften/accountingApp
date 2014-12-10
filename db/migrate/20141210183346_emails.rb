class Emails < ActiveRecord::Migration
  def change
  	create_table :emails do |e|
  		e.string :confirmation_key
  		e.string :email
  		e.integer :group_id
  		e.boolean :confirmed, default: false
  	end
  end
end
