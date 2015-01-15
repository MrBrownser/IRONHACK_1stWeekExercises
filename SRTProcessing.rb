#encoding: utf-8
require "pry"
require "time"
require "pp"

class SRTProcessing
	def initialize(filename)
		@entries = []
		# read and fulfill the entries array with every entry
		parse(filename)
	end

	def parse(filename)
		lines_str = IO.read(filename)
		entries_as_array = lines_str.split("\n\r\n")
		entries_as_array.each { |entry| split_entry(entry) }
	end

	def split_entry(entry)
		table_array = entry.split("\n")
		# 00:01:58,134 --> 00:02:00,753
		entry_index = table_array[0]
		start_time = table_array[1].split(" --> ")[0]
		end_time = table_array[1].split(" --> ")[1].gsub("\r","")
        content = ""
		for i in 2..table_array.length-1
			if table_array[i] != nil
		    	content += table_array[i]
	        end
	    end
		@entries << Entry.new(start_time, end_time, content, entry_index)
	end

	def get_entries
		@entries
	end

	def shift_all(milis)
		@entries.each { |entry| entry.shift_time(milis) }
	end

	def make_new_file(filename)
		final_output = ""
		@entries.each { |entry| final_output += entry.get_string }
		IO.write(filename, final_output)
	end

end

class Entry
	def initialize(start_time, end_time, content, entry_index)
		@start_time = start_time
		@end_time = end_time
		@content = content
		@entry_index = entry_index
	end

	def shift_time(milis)
		starting = Timeshifter.new(@start_time)
		@start_time = starting.add_time(milis)

		ending = Timeshifter.new(@end_time)
		@end_time = ending.add_time(milis)
	end

	def get_string
		@entry_index + "\n" + @start_time.strftime("%H:%M:%S,%L") + " --> " + @end_time.strftime("%H:%M:%S,%L") + "\n" + @content + "\n\n"
	end

	def get_content
		@content
	end

	def get_start_time
		@start_time
	end
end


class TimeShifter
    def initialize(time)
        @ini_time = Time.parse(time)
    end

    def add_time(milis)
    	@ini_time += milis/1000.to_f        
    end
end

class SpellChecker
	def initialize(entries, typos_filename)
		@entries = entries
		@typos_filename = typos_filename
		@typos = {}
	end

    def create_a_checklist
    	valid_words = IO.read(@typos_filename)
    	@entries.each do |entry|
    		entry.get_content.gsub(/[\r.:,?!&'-]/,' ').split(" ").each do |word|
    			if !(valid_words.include? word.downcase)
    				add_new_typo(word, entry.get_start_time())
    			end
       		end
       	end
       	print_typos_found()
    end


    private
    def add_new_typo(word, start_time)
    	@typos[word] ||= []
    	@typos[word] << start_time
    end

    def print_typos_found
    	typos_str = ""
    	
    	@typos.each do |actual_word, time|
    		typos_str += actual_word + ": " + time.to_s + "\n"
    	end

    	IO.write("potential_typos.txt", typos_str)
    end

end

processor_instance = SRTProcessing.new("LongExample.srt")
# processor_instance.shift_all(5000)
# processor_instance.shift_all(-2000)
# processor_instance.make_new_file("output.srt")
SpellChecker.new(processor_instance.get_entries, "words.txt").create_a_checklist()