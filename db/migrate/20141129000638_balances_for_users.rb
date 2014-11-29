class BalancesForUsers < ActiveRecord::Migration
  def change
  	create_table :balances do |b|
	  	b.integer :user_id
	    b.integer :group_id
	    b.decimal :amount
  	end
  end
end
