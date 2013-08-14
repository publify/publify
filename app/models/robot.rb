class Robot

  FILE = "#{::Rails.root.to_s}/public/robots.txt"
  DEFAULT_LINE = "User-agent: *\nAllow: /\nDisallow: /admin\n"

  attr_reader :robots

  def initialize
    unless File.exists?(FILE)
      robots = File.new(FILE, "w+")
      robots.write(DEFAULT_LINE)
      robots.close
    end
    @robots = File.new(FILE, "r+")
  end

  def add(rules)
    if File.writable?(FILE)
      robots.write(rules)
      robots.close
    end
  end

  def rules
    robots.readlines.join('')
  end
end
