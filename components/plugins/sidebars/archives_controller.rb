class Plugins::Sidebars::ArchivesController < Sidebars::Plugin
  def self.display_name
    "Archives"
  end

  def self.description
    'Displays links to monthly archives'
  end

  def self.default_config
    {'count' => 10, 'show_count' => true}
  end

  def content
    @archives = Hash.new

    Article.find(:all, :conditions => ['published != ?', false], :order => 'created_at DESC').each do |a|
      index = a.created_at.strftime("%Y-%m").to_sym

      if @archives[index].nil?
        break if @archives.size == @sb_config['count'].to_i # exit before we go over the limit

        @archives[index] = Hash.new(0)
        @archives[index][:name] = a.created_at.strftime("%B %Y")
        @archives[index][:year], @archives[index][:month] = index.to_s.split("-")
      end
      @archives[index][:count] += 1

    end

    @archives = @archives.sort_by { |index, month| index.to_s }.reverse.collect { |a| a.last }
  end

  def configure
  end
end
