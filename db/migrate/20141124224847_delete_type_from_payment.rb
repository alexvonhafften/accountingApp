class DeleteTypeFromPayment < ActiveRecord::Migration
  def change
  	remove_column :payments, :type
  end
end
