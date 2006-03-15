class Plugins::Sidebars::AmazonController < Sidebars::Plugin
  def self.display_name
    "Amazon"
  end

  def self.description
    "Adds sidebar links to any amazon books linked in the body of the page"
  end

  def self.default_config
    {'associate_id' => 'justasummary-20', 'maxlinks' => 4, 'title' => 'Cited books'}
  end

  def content
    asin_list = params[:contents].to_a.inject([]) { |acc, item| acc | item.whiteboard[:asins].to_a }
    @asins = asin_list.compact[0,@sb_config['maxlinks']]
    @assoc_id = @sb_config['associate_id']
    if @asins.empty?
      render :text => ""
      return
    end
  end

  def configure
  end
end
