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
	validates :content, presence: true, length: {minimum: 3 }
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

get "/details/:post_id" do
	# получаем параметр из URL
	post_id = params[:post_id]

  result = Post.find(post_id)

	# получаем объект, соответствующий строке

	@row = result

	#отображаем комменты к этому посту

  @rows = Comment.where(post_id: post_id).order 'created_at desc'
  # Это примерно следующее -  @rows = @db.execute 'select * from Comments  where post_id = ? order by id desc', [post_id]
  #возвращаем представление details.erb
	erb :details
end

post "/details/:post_id" do
	# получаем параметр из URL
  com = Comment.new
	com.post_id = params[:post_id]
	com.content = params[:comment]

	if com.save
		redirect("/details/" + com.post_id.to_s)
	else
		@error = com.errors.full_messages.first
		@rows = Comment.where(post_id: com.post_id).order 'created_at desc'
		@row = Post.find(com.post_id)

		erb :details
	end

end