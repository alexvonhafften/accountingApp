# app.rb
require 'rubygems'
require 'bundler/setup'
Bundler.require

require './models/User.rb'
require './models/Group.rb'
require './models/Payment.rb'

enable :sessions

set :session_secret, '85txrIIvTDe0AWPCvbeXuXXpULCWZgpoRo1LqY8YsR9GAbph0jfOHosvtY4QFxi6'

if ENV['DATABASE_URL']
	ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])
else
	ActiveRecord::Base.establish_connection(
		:adapter =>'sqlite3',
		:database => 'db/development.db',
		:encoding => 'utf8'
	)
end

before do
	@user = User.find_by(name: session[:name])
end


get '/' do
	if @user
		erb :user
	else
		erb :index
	end
end

post '/login' do
	# Get a handle to a user with a name that matches the
  # submitted username. Returns nil if no such user
  # exists
  user = User.find_by(email: params[:email])

  if user.nil?
    # first, we check if the user is in our database
    @message = "User not found."
    erb :message_page

  elsif user.authenticate(params[:password])
    # if they are, we check if their password is valid,
    # then actually log in the user by setting a session
    # cookie to their username
    session[:name] = user.name
    redirect '/'

  else
    # if the password doesn't match our stored hash,
    # show a nice error page
    @message = "Incorrect password."
    erb :message_page
  end
end


#handle registration of a new user
post '/new_user' do
	@user = User.create(params)
	if @user.valid?
		session[:name] = @user.name
    	redirect '/'
	else
    	@message = @user.errors.full_messages.join(', ')
    	erb :message_page
	end
end

#handle creation of new group
post '/new_group' do
	if @user
		@user.groups.create(name: params[:name])
		redirect '/'
	else
		@message = "You Must Be Logged In To Create A Group"
		erb :message_page
	end
end

#handle creation of new payment
post '/new_payment' do
	if @user
		group = Group.find(params[:group_id])
		Payment.create(user: @user, group: group, name: params[:name], amount: params[:amount], due: params[:due])
		redirect '/'
	else
		@message = "You Must Be Logged In To Create A Payment"
		erb :message_page
	end	
end

get '/delete' do
	if @user
		@type = params[:type]
		@id = params[:id]
		if @type == 'g'
			@group = Group.find(@id)
		end
		erb :delete
	else
		@message = "You Must Be Logged In To Delete Items"
		erb :message_page
	end
end

post '/delete' do
	if @user
		if params[:type] == 'g' #deactivate a group
			@group = Group.find(params[:id])
			@group.update(active: 'false')
		elsif params[:type] == 'u' #deactivate a user
			@user.update(active: 'false')
		end
		redirect '/'
	else
		@message = "You Must Be Logged In To Delete Items"
		erb :message_page
	end	
end

get '/logout' do
	session.clear
	redirect '/'
end

get '/account' do
	erb :account
end