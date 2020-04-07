require 'sinatra'
require "sinatra/reloader" if development?


enable :sessions

get "/" do
	"Hello world"
end
