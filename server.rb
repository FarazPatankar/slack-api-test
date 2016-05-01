require "sinatra"
require "sinatra/reloader" if development?
require 'httparty'
require 'sinatra/json'
require 'json'
require 'pry'

require_relative("lib/ruby_doc_parser.rb")

get '/' do
	"Hi"
end

post '/docs' do
	text = params["text"]
	# binding.pry
	if text.match(/[a-zA-Z]+([#]|[:]{2})[a-zA-Z_]+/)
		ruby_doc_parser = RubyDocParser.new(text)
		ruby_doc_parser.response
	else
		json :text => "Bro, you're doing it wrong. DAT attachment tho\n*Format : * `Class#method`\n*Example : * `String#reverse`"
	end
end