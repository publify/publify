class SiteTracker < ActiveRecord::Base
  set_table_name 'sitealizer'
  
  def self.find_browsers(params={})
    browsers = {}
    tmp = []
    r = find_by_sql("SELECT user_agent, COUNT(*) AS total FROM sitealizer WHERE created_on "+
                    "LIKE '#{params[:year]}-#{params[:month]}%' GROUP BY user_agent ORDER BY total DESC")
    r.each{|env|
      browser_info = Sitealizer::Parser::UserAgent.browser_info(env.user_agent)
      tmp << {:total => env.total, :browser => browser_info[:type], :version => browser_info[:version]}
    }
    tmp.each{|set| n = "#{set[:browser]}|#{set[:version]}"; browsers[n] = (browsers[n]||0) + set[:total].to_i}
    browsers = browsers.inject([]){|a,v| 
      name = v[0].split("|")
      a << {:browser => {:type => name[0], :version => name[1]}, :total => v[1]}
    }
    return browsers.sort{|x,y| y[:total] <=> x[:total]}
  end
  
  def self.find_platforms(params={})
    platforms = {}
    tmp = []
    r = find_by_sql("SELECT user_agent, COUNT(*) AS total FROM sitealizer WHERE created_on "+
                    "LIKE '#{params[:year]}-#{params[:month]}%' GROUP BY user_agent ORDER BY total DESC")
    r.each{|env|
      tmp << {:total => env.total, :name => Sitealizer::Parser::UserAgent.get_platform(env.user_agent)}
    }
    tmp.each{|set| platforms[set[:name]] = (platforms[set[:name]]||0) + set[:total].to_i}
    platforms = platforms.inject([]){|a,v| a << {:name => v[0], :total => v[1]}}
    return platforms.sort{|x,y| y[:total] <=> x[:total]}
  end
  
  def self.find_robots(params={})
    robots = {}
    tmp = []
    r = find_by_sql("SELECT user_agent, COUNT(*) AS total FROM sitealizer WHERE created_on "+
                    "LIKE '#{params[:year]}-#{params[:month]}%' GROUP BY user_agent ORDER BY total DESC")
    r.each{|env|
      bot = Sitealizer::Parser::Robot.get_name(env.user_agent)
      tmp << {:total => env.total, :name => bot} if bot
    }
    tmp.each{|set| robots[set[:name]] = (robots[set[:name]]||0) + set[:total].to_i}
    robots = robots.inject([]){|a,v| a << {:name => v[0], :total => v[1]}}
    return robots.sort{|x,y| y[:total] <=> x[:total]}
  end
  
  def self.find_search_terms(params={})
    terms = {}
    tmp = []
    r = find_by_sql("SELECT referer, COUNT(*) AS total FROM sitealizer WHERE created_on "+
                    "LIKE '#{params[:year]}-#{params[:month]}%' GROUP BY referer ORDER BY total DESC LIMIT 30")
    r.each{|env|
      term = Sitealizer::Parser::Keyword.get_terms(env.referer)
      tmp << {:total => env.total, :query => term} if term
    }
    tmp.each{|set| terms[set[:query]] = (terms[set[:query]]||0) + set[:total].to_i}
    terms = terms.inject([]){|a,v| a << {:query => v[0], :total => v[1]}}
    return terms.sort{|x,y| y[:total] <=> x[:total]}
  end
  
  def self.find_domains(params={})
    domains = {}
    tmp = []
    r = find_by_sql("SELECT referer, COUNT(*) AS total FROM sitealizer WHERE created_on "+
                    "LIKE '#{params[:year]}-#{params[:month]}%' GROUP BY referer ORDER BY total DESC LIMIT 30")
    r.each{|env|
      domain = Sitealizer::Parser::Keyword.get_domain(env.referer, params[:host])
      tmp << {:total => env.total, :domain => domain} if domain
    }
    tmp.each{|set| domains[set[:domain]] = (domains[set[:domain]]||0) + set[:total].to_i}
    domains = domains.inject([]){|a,v| a << {:domain => v[0], :total => v[1]}}
    return domains.sort{|x,y| y[:total] <=> x[:total]}
  end
  
  def self.find_referers(params={})
    find_by_sql("SELECT referer, COUNT(*) AS total " +
                "FROM sitealizer WHERE created_on LIKE '#{params[:year]}-#{params[:month]}%' "+ 
                "GROUP BY referer ORDER BY total DESC LIMIT 30")
  end
  
  def self.find_page_urls(params={})
    find_by_sql("SELECT path, COUNT(*) AS total " +
                "FROM sitealizer WHERE created_on LIKE '#{params[:year]}-#{params[:month]}%' "+ 
                "GROUP BY path ORDER BY total DESC LIMIT 30")
  end
  
  def self.find_hosts(params={})
    find_by_sql("SELECT ip, COUNT(*) AS total FROM sitealizer WHERE "+
                "created_on LIKE '#{params[:year]}-#{params[:month]}%' "+ 
                "GROUP BY ip ORDER BY total DESC LIMIT 30")
  end
  
  def self.find_languages(params={})
    find_by_sql("SELECT language, COUNT(*) AS total FROM sitealizer WHERE "+
                "created_on LIKE '#{params[:year]}-#{params[:month]}%'  "+ 
                "GROUP BY language ORDER BY total DESC LIMIT 15")
  end
  
  def self.count_hits(params={})
    count = !params[:count] ? "*" : params[:count]
    date  = !params[:date] ? "#{params[:year]}-#{params[:month]}%" : params[:date]
    count_by_sql("SELECT COUNT(#{count}) FROM sitealizer WHERE created_on LIKE '#{date}'")
  end
  
  def self.find_monthly_hits(params={})
    dataset = []
    12.times{|month| month+=1
      created = "#{params[:year]}-#{sprintf("%02d",month)}-%"
      date = "#{params[:year]}-#{month}-1".to_time.strftime('%B %Y')
      date_short = "#{params[:year]}-#{month}-1".to_time.strftime('%b %Y')
      visits = count_by_sql("SELECT COUNT(DISTINCT ip) FROM sitealizer WHERE created_on LIKE '#{created}'")
      hits   = count_by_sql("SELECT COUNT(*) FROM sitealizer WHERE created_on LIKE '#{created}'")
      dataset << [date_short, visits, hits, date]
    }
    dataset    
  end
  
  def self.find_daily_hits(params={})
    dataset = []
    days_in_mon = Date.civil(params[:year].to_i, params[:month].to_i, -1).day
    days_in_mon.times{|day| day+=1
      created = "#{params[:year]}-#{params[:month]}-#{sprintf("%02d",day)}"
      date = "#{params[:year]}-#{params[:month]}-#{day}".to_time.strftime('%b %d %Y')
      visits = count_by_sql("SELECT COUNT(DISTINCT ip) FROM sitealizer WHERE created_on = '#{created}'")
      hits   = count_by_sql("SELECT COUNT(*) FROM sitealizer WHERE created_on = '#{created}'")
      dataset << [day, visits, hits, date]
    }
    dataset
  end
  
  def self.find_hourly_hits(params={})
    dataset = []
    24.times{|hour|
      hour = sprintf("%02d",hour)
      visits = count_by_sql("SELECT COUNT(DISTINCT ip) FROM sitealizer "+
                            "WHERE created_at LIKE '#{params[:year]}-#{params[:month]}% #{hour}:%'")
      hits = count_by_sql("SELECT COUNT(*) FROM sitealizer WHERE "+
                          "created_at LIKE '#{params[:year]}-#{params[:month]}% #{hour}:%'")
      dataset << [hour.to_s, visits, hits]
    }
    dataset
  end
  
end