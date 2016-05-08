class RubyDocParser
	def initialize(search_string)
		@search_string = search_string
	end

	def response
		class_method = @search_string.gsub("?", "").split('#')
		ruby_class, ruby_method = class_method[0], class_method[1]

		doc = Nokogiri::HTML(open("http://ruby-doc.org/core-2.3.0/#{ruby_class.capitalize}.html"))
		# binding.pry

		container = ""

		doc.css("##{ruby_method}-method").css("pre").css(".ruby").each do |tag|
			container += tag.content
		end

		if container == ""
			doc.css("div[id*=#{ruby_method}]").css("pre").css(".ruby").each do |tag|
				container += tag.content
			end
		end

		container.empty? ? "No examples for that method. :(" : container
	end
end