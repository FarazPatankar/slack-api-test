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
		class_method = text.gsub("?", "").split('#')
		ruby_class, ruby_method = class_method[0], class_method[1]

		ruby_doc_parser = RubyDocParser.new(text)


		response = ruby_doc_parser.response
		content_type :json
				p response
		{
			:response_type => 'in_channel',
			:text => "Link : http://ruby-doc.org/core-2.2.0/#{ruby_class.capitalize}.html#method-i-#{ruby_method.downcase}",
			:attachments => [
				{
					:text => "`#{response.gsub('"', "'").reverse.sub("\n","").reverse.gsub("\n", "`\n`")}`",
					:mrkdwn_in => ["text"]
				}
			],
			:mrkdwn => true
		}.to_json
	else
		json :text => "Bro, you're doing it wrong. DAT attachment tho\n*Format : * `Class#method`\n*Example : * `String#reverse`"
	end
end