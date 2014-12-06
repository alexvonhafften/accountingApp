class GroupTotalBalance < ActiveRecord::Migration
  def change
  	change_table :groups do |g|
  		g.decimal :balance 
  	end
  end
end
