# app.rb
require 'rubygems'
require 'bundler/setup'
Bundler.require
Dotenv.load

require './models/User.rb'
require './models/Group.rb'
require './models/Payment.rb'
require './models/Balance.rb'

enable :sessions

set :session_secret, ENV['SESSION_SECRET']

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

get '/archive' do
	if @user.groups.include?(Group.find(params[:id]))
		@group = Group.find(params[:id])
		erb :archive
	else
		@message = "You do not have permission to view this page, you are not a part of this group."
		erb :message_page
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
		Balance.create(user: @user, group: Group.last)
		unless params['emails'].nil?
			add_members_to_group(params['emails'].split(','), Group.last.id)
		end
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
		#calculate balances
		calculate_balances(group)
		redirect '/'
	else
		@message = "You Must Be Logged In To Create A Payment"
		erb :message_page
	end	
end

post '/new_group_member' do
	if @user
		add_members_to_group(params['emails'].split(','), params['id'])
	else
		@message = "You Must Be Logged In To Add Users To Groups"
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
		if params[:type] == 'g' && params[:confirm] == 'yes' #deactivate a group
			@group = Group.find(params[:id])
			@group.update(active: 'false')
		elsif params[:type] == 'u' && params[:confirm] == 'yes' #deactivate a user
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

get '/profile' do
	erb :profile
end

get '/email' do
	if @user
		group = Group.find(params[:id])
		
		group.users.each do |u|
			html_body = generate_email_body(group, u)
			send_email(u.email,html_body)
		end

		#archive payments
		group.payments.each do |p|
			p.update(active: false)
		end

		#reset balances
		calculate_balances(group)
	else 
		@message = "You Must Be Logged In To Send Invoice"
		erb :message_page
	end

	redirect '/'
end



#####################
# Helpers

helpers do

	def add_members_to_group(emails, group_id)
	
		group = Group.find(group_id)

		emails.each do |e|
			e = e.strip
			new_member = User.find_by(email: e)

			if @user.groups.include?(group) #new_member has an account and user is associated with group
				unless new_member
					User.create(email: e)
					new_member = User.find_by(email: e)
					send_email(e, new_user_email_body(e))
				end

				unless new_member.groups.include?(group) #unless this memeber is already in the group
					new_member.groups << group #new_member is added to group
					Balance.create(user: new_member, group: group)
				end
			else #@user is not associated with requested group.
				@message = "User does not have permission to edit this group"
				erb :message_page
			end
		end
		calculate_balances(group)
		redirect '/'
	end


	def calculate_balances(group)
		group_sum = 0

		#add total for the group
		group.payments.where(active: true).each do |p|
				group_sum += p.amount
		end

		group.update(balance: group_sum) #update the group balance
		user_share = group_sum / group.users.size

		#find each user's balance
		group.users.each do |u|
			user_sum = 0
			u.payments.where(group: group, active: true).each do |p|
				user_sum += p.amount
			end
			#update in the balances table
			u.balances.find_by(group: group).update(amount: user_share - user_sum)
		end

	end

	def send_email(email, body)
		Pony.mail({
		  :to => email,
		  :via => :smtp,
		  :html_body => body,
		  :via_options => {
		    :address              => 'smtp.gmail.com',
		    :port                 => '587',
		    :enable_starttls_auto => true,
		    :user_name            => ENV['EMAIL_USERNAME'],
		    :password             => ENV['EMAIL_PASSWORD'],
		    :authentication       => :plain, # :plain, :login, :cram_md5, no auth by default
		  }
		})

	end

	def generate_email_body(group, user)

		body = "<h1>Here is the invoice for #{group.name}</h1>"


		user_balance = user.balances.find_by(group: group)
		
		if user_balance > 0
			body += '<h2>You owe the group $#{user_balance}0</h2>'
		elsif user_balance < 0
			body += '<h2>The group owes you $#{user_balance*-1}0</h2>'
		else 
			body += '<h2>You do not owe money.</h2>'
		end
		
		group.payments.where(active: true).each do |p|
			body += "<li><h3>#{p.name} #{p.amount}</h3><p>Paid by: #{p.user.name}</p></li>"
		end

		group.balances.each do |b|
			body += "<h2>#{b.user.name} : #{b.amount} </h2>"
		end

		return body
	end

	def new_user_email_body(email)
		body = '<h1>Welcome to SWAGcounting++</h1><p>Click <a href="https://accounting-app.herokuapp.com/?email="#{email}">here</a> to register for your account!</p>'

	end
end





