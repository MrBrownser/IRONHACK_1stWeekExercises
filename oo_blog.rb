require 'pry'
require 'date'

class Post

	attr_reader :date

	def initialize(title, date, text, is_sponsored)
		@title = title
		@date = date
		@text = text
		@is_sponsored = is_sponsored
	end

	def print_post
		if (@is_sponsored)
			puts "******" + @title + "******" + "\n**************\n" + @text + "\n----------------"
		else
			puts @title + "\n**************\n" + @text + "\n----------------"
		end
	end

end

class Blog
	def initialize()
		@post_list = []
	end
	
	def addPost(title, date, text, is_sponsored)
		@post_list << Post.new(title, date, text, is_sponsored)
		@post_list.sort_by { |x| x.date }
	end

	def front_page
		@post_list.each do |actual_post|
			actual_post.print_post
		end
	end
end

test_blog = Blog.new()

test_blog.addPost("OLDEST POST", DateTime.now.strftime('%s'), "Test oldest post", false)
test_blog.addPost("MID POST", DateTime.now.strftime('%s'), "Test mid text", true)
test_blog.addPost("NEWEST POST", DateTime.now.strftime('%s'), "Test new text", false)

test_blog.front_page