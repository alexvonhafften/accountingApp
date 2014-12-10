class Group < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :emails #unregistered users getting emails from the server.
  has_many :payments
  has_many :balances
end
