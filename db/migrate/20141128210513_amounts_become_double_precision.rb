class AmountsBecomeDoublePrecision < ActiveRecord::Migration
  def change
  	remove_column :payments, :amount
  	change_table :payments do |p|
  		p.decimal :amount
  	end
  end
end
