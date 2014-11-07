# app.rb
require 'rubygems'
require 'bundler/setup'
Bundler.require
require './models/TodoItem'

if ENV['DATABASE_URL']
	ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])
else
	ActiveRecord::Base.establish_connection(
		:adapter =>'sqlite3',
		:database => 'db/development.db',
		:encoding => 'utf8'
	)
end

get '/' do
	@task = TodoItem.all.order(:due_date)
	erb :index
end

post '/' do
	TodoItem.create(params)
	redirect '/'
end

get '/delete/:id' do
	TodoItem.find(params[:id]).destroy
	redirect '/'
end

helpers do
	def blank?(x)
		x.nil? || x == ""
	end

	def delete(x)
		TodoItem.find(description = 'x').destroy()
		redirect '/'
	end
end
