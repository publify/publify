class LangaugeFile

  def executeStage(message)
    puts message
    yield
  end

  def generate_language_file(language,duplicate)
    filename = File.join("lang", "#{language}.rb");


    stringMap = {}
    executeStage "Loading last language file #{filename}" do
      File.read(filename).scan(/["](.*?)["],(.*)/u).each do |pp|
        stringMap[pp[0]] = pp[1]
      end
    end

    stringAll = []
    executeStage "Generating #{filename}" do
      rc  = ""
      rc += "Localization.define(\"#{language}\") do |l|"
      Dir.glob("**/*.{erb,rhtml,rb}").sort.collect do |ff|
        strings   = File.read(ff).scan(/_\([ ]*["](.*?)["]/)
        strings  += File.read(ff).scan(/_\([ ]*['](.*?)[']/)
        if strings.length > 0
          strings.uniq!
          stringsRemove = strings
          strings -= stringAll
          stringAll += stringsRemove
          stringAll.uniq!
          if strings.length > 0
            rc += "\n\n  # #{ff}"
            strings.each do |ss|
              key = ss[0]
              if ( duplicate )
                rc += "\n  l.store \"#{key}\", \"#{key}\""
              else
                if stringMap.has_key?(key)
                  rc += "\n  l.store \"#{key}\",#{stringMap[key]}"
                  stringMap.delete(key)
                else
                  rc += "\n  l.store \"#{key}\", \"\""
                end
              end
            end
          end
        end
      end
      if stringMap.size > 0
        rc += "\n\n  # Obsolete translations"
        stringMap.keys.sort.each do |key|
          rc += "\n  l.store \"#{key}\",#{stringMap[key]}"
        end
      end
      rc += "\nend\n"
      ff = File.new(filename,"w")
      ff.write(rc)
      ff.close()
    end
  end
end

class Tool
  def initialize
    @language  = 'en_US'
    @duplicate = true

    if ( ARGV[0] )
      @language  = ARGV[0]
      @duplicate = false
    end
  end

  def run
    lang = LangaugeFile.new
    lang.generate_language_file(@language,@duplicate);
  end
end

# should be run on the Rails directory
tool = Tool.new
tool.run

