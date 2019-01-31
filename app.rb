#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

set :database, "sqlite3:blog_act.db"

class Post < ActiveRecord::Base

	validates :author, presence: true, length: {minimum: 3 }
	validates :content, presence: true

end

class Comment <ActiveRecord::Base

end

get '/' do
	@posts = Post.order 'created_at desc'
	erb :index
end

get '/new' do
  @p = Post.new
	erb :new
end

post '/new' do

  @p = Post.new params[:post]

  if @p.save
    redirect('/')
  else
    @error = @p.errors.full_messages.first
    erb :new
  end
end