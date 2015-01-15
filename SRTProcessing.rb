require "pry"
require "time"


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
	def initialize (entries, filename)
		@entries = entries
		@filename = filename
	end

    def create_a_checklist
    	file = IO.read(@filename)
    	entries.each do |entry|
    		entry.get_content.gsub(/[\r]/,' ').split(" ").each do
       			if #file.include? "#{entry.content.}"
       		end
       	end
       	file << entriescontent.spilt(" ")
    end
end

processor_instance = SRTProcessing.new("ShortExample.srt")
processor_instance.shift_all(5000)
processor_instance.shift_all(-2000)
processor_instance.make_new_file("output.srt")

Spellchecker.new(processor_instance.get_entries, "words.txt").create_a_checklist