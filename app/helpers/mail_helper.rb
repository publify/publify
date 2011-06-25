module MailHelper
  # Mutter... ActionMailer doesn't do fragment caching.
  def html(content, what=:all)
    content.html(what)
  end

  # Helper method to get the blog object.
  def this_blog
    @blog ||= Blog.default
  end

  def new_js_distance_of_time_in_words_to_now(date)
    time = _(date.utc.strftime(_("%%a, %%d %%b %%Y %%H:%%M:%%S GMT", date.utc)))
    timestamp = date.utc.to_i ;
    "<span class=\"typo_date date gmttimestamp-#{timestamp}\" title=\"#{time}\" >#{time}</span>"
  end

  def display_date(date)
    date.strftime(this_blog.date_format)
  end

  def display_time(time)
    time.strftime(this_blog.time_format)
  end

  def display_date_and_time(timestamp)
    return new_js_distance_of_time_in_words_to_now(timestamp) if this_blog.date_format == 'distance_of_time_in_words'
    "#{display_date(timestamp)} #{_('at')} #{display_time(timestamp)}"
  end

end

