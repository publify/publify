class Plugins::Sidebars::AmazonController < Sidebars::ComponentPlugin
  description "Adds sidebar links to any amazon books linked in the body of the page"

  setting :title,        'Cited books'
  setting :associate_id, 'justasummary-20'
  setting :maxlinks,      4

  def content
    asin_list = params[:contents].to_a.inject([]) { |acc, item| acc | item.whiteboard[:asins].to_a }
    @asins = asin_list.compact[0,@sb_config['maxlinks'].to_i]
    @assoc_id = @sb_config['associate_id']
    if @asins.empty?
      render :text => ""
      return
    end
  end
end
