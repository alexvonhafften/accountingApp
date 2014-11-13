class User < ActiveRecord::Base
  has_many :payments
  has_and_belongs_to_many :groups
end