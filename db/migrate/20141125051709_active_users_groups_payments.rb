#Active is a archival system. Something is archived if Active == 'false' == 0

class ActiveUsersGroupsPayments < ActiveRecord::Migration

  def change
  	change_table :users do |u|
  		u.boolean :active, default: true
  	end

  	change_table :groups do |g|
  		g.boolean :active, default: true
  	end

  	change_table :payments do |p|
  		p.boolean :active, default: true
  	end
  
    remove_column :payments, :done
  end
end
