module NotesHelper
  def get_reply_context_url(reply)
    begin
      return reply['user']['entities']['url']['urls'][0]['expanded_url']
    rescue
      return "https://twitter.com/#{reply['user']['name']}"
    end
  end
  
  def get_reply_context_twitter_link(reply)
    link_to(display_date_and_time(reply['created_at'].to_time), "https://twitter.com/#{reply['user']['screen_name']}/status/#{reply['id_str']}")    
  end
end