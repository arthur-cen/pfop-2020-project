require 'sinatra'
require "sinatra/reloader" if development?

enable :sessions

################################################################
###########                                    #################
###########     Part 2: Working with Arrays    #################
###########                BEGIN               #################
###########                                    #################
################################################################

morning_greetings = ["Good morning!", "Morning!", "Good day!", "Buenas Días!"]
afternoon_greetings = ["Good afternoon!", "Buenas tardes!"]
other_greetings = ["Hello! ", "Hi there! ", "Welcome! ", "Bazinga! "]

# using conditional statements to choose different greetings at different times
t = Time.now
if t.hour < 12 and t.hour > 3
	greetings = morning_greetings
	# puts "using morning greetings"
elsif t.hour >= 12 and t.hour < 19
	# puts "using afternoon greetings"
	greetings = afternoon_greetings
else
	greetings = other_greetings
	# puts "using other greetings"
end

#example of how to store value in one session
get '/' do
	if session["count"].nil?
		session["count"] = 1
	else
		session["count"] += 1
	end
	redirect to('/about'), 303
end	

get "/about" do
	if session["first_name"].nil?
		"#{greetings.sample(1)[0]}!"
	else
		"#{greetings.sample(1)[0]}, #{session["first_name"]}!"
	end
end

################################################################
###########                                    #################
###########     Part 2: Working with Arrays    #################
###########                 END                #################
###########                                    #################
################################################################


get '/set_name/:name' do
  
  # here we're assigning the parameter
  # into a session variable 
  # this information then persists across
  # requests to the webservice
  # i.e. the server will maintain this information
  # specific to a single visitor / user
  
  session["name"] = params["name"]
  "Hello there, " + params["name"]
end

secrete_code = "happymonday"

get "/signup" do
	if params['code'] and params['code'] == secrete_code
		"Signup with secrete code"
	else
		"Signup as normal user"
	end
end

get "/signup/:first_name/:number" do
	session["first_name"] = params["first_name"]
	session["number"] = params["number"]
	"I got your info. Name:#{session[:first_name]}. Number: #{session[:number]}"
end


get '/unset_name' do
  session["name"] = nil
end


# get "/about" do
# 	if session["name"].nil?
# 		'Welcome! '
# 	else
# 		'Welcome back ' + session["name"] + "! "
# 	end
# end



#example of how to put integer in string
get "/count_visits" do
	if session["count"].nil?
		"your visits = 0"
	else
		"your visits = #{session["count"]}"
	end
end

# get "/hello" do 
# 	greetings.sample(1)[0] + " How are you?"
# end

# get '/hello/:name' do
#     greetings.sample(1)[0] + params["name"]
# end

# # this is a basic route named hello that
# # takes a parameter called first and last

# get '/hello/:first/:last' do
#     "Hello, " + params["first"] + " " + params[:last]
# end

# get "/signup" do 
# 	"This is the signup page"
# end

get "/incoming/sms" do 
	403
end


get "/test/conversation" do #Note that you do not need to include the param in the url, this is fine
	if !params["Body"].nil? # check if Body is popu
		return determine_response params["Body"] #{Body -> "joke", From -> "12345"}
	end
	"Nothing here"
end

error 404 do
	"I can’t find that. 404 bad url."
end

error 403 do
	"403, Access forbidden"
end

def determine_response body
	norm_body = body.strip.downcase
	if norm_body == "hi"
		return "Hello I am a happy bot"	
	elsif norm_body == "who"
		return "I am a happy and healthy bot"
	elsif norm_body == "what"
		return "I can tell you a joke, a story or sing you a song"
	elsif norm_body == "where"
		return "I live in a server based in pittsburgh"
	elsif norm_body == "when"
		return "I was created on March 27th. 2020"
	elsif norm_body == "why"
		return "I am here to help you, you can ask me any question"
	elsif norm_body == "joke"
		joke_lines = IO.readlines("jokes.txt")
		return joke_lines.sample
	else
		return "Sorry, I do not understand what you just said."
	end
end