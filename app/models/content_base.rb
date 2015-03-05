module ContentBase
  def self.included(base)
    base.extend ClassMethods
  end

  def blog
    @blog ||= Blog.default
  end

  attr_accessor :just_changed_published_status
  alias_method :just_changed_published_status?, :just_changed_published_status

  def really_send_notifications
    interested_users.each do |value|
      send_notification_to_user(value)
    end
    true
  end

  def send_notification_to_user(user)
    notify_user_via_email(user)
  end

  # Return HTML for some part of this object.
  def html(field = :all)
    if field == :all
      generate_html(:all, content_fields.map { |f| self[f].to_s }.join("\n\n"))
    elsif html_map(field)
      generate_html(field)
    else
      raise "Unknown field: #{field.inspect} in content.html"
    end
  end

  # Generate HTML for a specific field using the text_filter in use for this
  # object.
  def generate_html(field, text = nil)
    text ||= self[field].to_s
    prehtml = html_preprocess(field, text).to_s
    html = (text_filter || default_text_filter).filter_text_for_content(blog, prehtml, self) || prehtml
    html_postprocess(field, html).to_s
  end

  # Post-process the HTML.  This is a noop by default, but Comment overrides it
  # to enforce HTML sanity.
  def html_postprocess(_field, html)
    html
  end

  def html_preprocess(_field, html)
    html
  end

  def html_map(field)
    content_fields.include? field
  end

  def excerpt_text(length = 160)
    if respond_to?(:excerpt) && (excerpt || '') != ''
      text = generate_html(:excerpt, excerpt)
    else
      text = html(:all)
    end

    text = text.strip_html

    text.slice(0, length) +
      (text.length > length ? '...' : '')
  end

  def invalidates_cache?(on_destruction = false)
    @invalidates_cache ||= if on_destruction
                             just_changed_published_status? || published?
                           else
                             (changed? && published?) || just_changed_published_status?
                           end
  end

  def publish!
    self.published = true
    self.save!
  end

  # The default text filter.  Generally, this is the filter specified by blog.text_filter,
  # but comments may use a different default.
  def default_text_filter
    blog.text_filter_object
  end

  module ClassMethods
    def content_fields(*attribs)
      class_eval "def content_fields; #{attribs.inspect}; end"
    end

    def default_order
      'published_at DESC'
    end
  end
end
