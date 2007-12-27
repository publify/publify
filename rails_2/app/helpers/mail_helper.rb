module MailHelper
  # Mutter... ActionMailer doesn't do fragment caching.
  def html(content, what=:all)
    content.html(what)
  end
end

