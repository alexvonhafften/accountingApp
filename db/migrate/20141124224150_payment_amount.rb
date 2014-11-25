class PaymentAmount < ActiveRecord::Migration
  def change
  	change_table :payments do |t|
  		t.string :amount
  	end
  end
end
