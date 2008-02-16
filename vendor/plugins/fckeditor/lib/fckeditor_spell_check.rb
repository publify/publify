# Interfaces with aspell and returns results ready for FCKeditor-friendly javascript
class FckeditorSpellCheck
  cattr_accessor :language

  @@language ||= "en_US"

  # call aspell and retrieve the results
  def self.check_spelling(text)
    if RUBY_PLATFORM =~ /mswin/i
      aspell_program = 'c:\program files\aspell\bin\aspell' # windows
    else 
      aspell_program = 'aspell' # every other OS on the planet
    end
    
    # call aspell
    command = "\"#{aspell_program}\" -a --lang=#{language} --encoding=utf-8 -H 2>&1"
    RAILS_DEFAULT_LOGGER.info("Running spell check: #{command}")
    output = IO.popen(command, 'r+') {|io| io.puts(text); io.close_write; io.read }

    # return an array of results
    output.split("\n").collect {|line| parse_aspell_line(line) }.compact
  end

 private
  # return a 2-D array of results, where each element in the array has a pair
  # of values: [ escaped word, comma separted list of escaped suggestions ]
  def self.parse_aspell_line(line)
    if line =~ /^&/
      details = line.split(' ', 5)
      [ escape(details[1]), get_suggestions(details[4]) ]
    end
  end

  # quote and escape the individual suggestions
  def self.get_suggestions(value)
    value.split(', ').collect {|x| "'#{escape(x)}'"}.join(', ')
  end

  # properly escape single-quote for javascript
  def self.escape(x)
    x.gsub(/'/, '\\\\\'')
  end
end