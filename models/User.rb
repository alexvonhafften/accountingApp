class User < ActiveRecord::Base
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  has_many :payments
  has_many :balances
  has_and_belongs_to_many :groups
  has_secure_password
end
