# app.rb
require 'rubygems'
require 'bundler/setup'
Bundler.require

require './models/User.rb'
require './models/Group.rb'
require './models/Payment.rb'

enable :sessions

if ENV['DATABASE_URL']
	ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])
else
	ActiveRecord::Base.establish_connection(
		:adapter =>'sqlite3',
		:database => 'db/development.db',
		:encoding => 'utf8'
	)
end

GET '/' do
	erb :index
end

POST '/' do

	user = User.find_by(name: params[:user_name])
	if user.nil?
		return 'User not found'
	if user.Authenticate(params[:password]) do
		session[:username] = user.name
		redirect '/u/'+user.name
	else
		return 'Login Failed'
	end
	# for returning user
	#  login
	# for new user
	#  get info and go to create groups page
end

GET '/logout' do
	session.clear
end

GET '/groups' do
	@User = User.find_by(name: session[:username])
	erb :user
end

POST '/groups' do
  # can create payment
	# can create group
end

GET '/g/:group_id' do
	@Group = Group.find_by(group_id: params[:group_id])
	erb :group
end

POST '/g/:group' do
  # add new member users
	# post new payment
end
