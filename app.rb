# app.rb
require 'rubygems'
require 'bundler/setup'
Bundler.require

require './models/User.rb'
require './models/Group.rb'
require './models/Payment.rb'

if ENV['DATABASE_URL']
	ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])
else
	ActiveRecord::Base.establish_connection(
		:adapter =>'sqlite3',
		:database => 'db/development.db',
		:encoding => 'utf8'
	)
end

GET '/'
	erb :index
end

POST '/'
	# for returning user
	#  login
	# for new user
	#  get info and go to create groups page
end

GET '/u/:user'
	@User = User.find_by(name: params[:user])
	erb :user
end

POST '/u/:user'
  # can create payment
	# can create group
end

GET '/g/:group_id'
	@Group = Group.find_by(group_id: params[:group_id])
	erb :group
end

POST '/g/:group'
  # add new member users
	# post new payment
end
