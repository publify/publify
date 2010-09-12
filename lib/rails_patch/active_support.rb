# Work-around for https://rails.lighthouseapp.com/projects/8994/tickets/4695-string-added-to-rails_helpers-gets-html-escaped
class ActiveSupport::SafeBuffer
  def concat(*args) super end
  alias << concat
end
