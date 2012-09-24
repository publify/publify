require 'converters/timtab/post'
require 'converters/timtab/comment'
require 'converters/timtab/category'

class TimtabConverter < BaseConverter

  def self.convert(options={})
    converter = new(options)

    # not implemented
    #converter.import_users

    user = ::User.first

    converter.import_articles do |tt_article|
      date_created = Time.at(tt_article.crdate).to_datetime
      date_modified = Time.at(tt_article.tstamp).to_datetime
      date_published = Time.at(tt_article.datetime).to_datetime

      tag_strs = tt_article.keywords.split(',').map { |k| k.strip }
      cat_strs = tt_article.categories.map { |c| c.title }

      article_tags = converter.find_or_create_tags(tag_strs)
      article_cats = converter.find_or_create_categories(cat_strs)

      article = ::Article.new do |a|
        a.title = tt_article.title
        a.body = converter.convert_text(tt_article.bodytext)
        a.created_at = date_created
        a.updated_at = date_modified
        a.published_at = date_published

        a.author = user
        a.tags = article_tags
      end

      [article, article_cats]
    end

    converter.import_comments do |tt_comment|
      date_created = Time.at(tt_comment.crdate).to_datetime

      comment = ::Comment.new do |c|
        c.body = tt_comment.content
        c.created_at = date_created
        c.updated_at = date_created
        c.published_at = date_created
        c.author = tt_comment.firstname
        c.email = tt_comment.email
        c.url = tt_comment.homepage
        c.ip = tt_comment.remote_addr
      end

      comment
    end

  end

  def old_articles
    Timtab::Post.includes(:categories).where(:hidden => 0).where(:deleted => 0).where(:type => 3)
  end

  # @param array of strings containing tag names
  # @return array of tags
  def find_or_create_tags(tag_array)
    tag_array.map do |t|
      if tags[t].nil?
        create_tag(t)
      else
        tags[t]
      end
    end
  end

  # @param array of string containing category names
  # @return array of categories
  def find_or_create_categories(cat_array)
    cat_array.map do |c|
      if categories[c].nil?
        create_categories(c)
      else
        categories[c]
      end
    end
  end

  def convert_text(text)
    parse_paragraphs(
    parse_typo3_link(
    parse_code_block(
    parse_quote_block(
      text.strip
    ))))
  end

  def parse_typo3_link(text)
    text.gsub(/<link\s+([^>\s]*).*?>([^<].*?)<\/link>/i) do
      target = ($1.start_with?('http')) ? '_blank' : ''
      "<a href='#{$1}' target='#{target}'>#{$2}</a>"
    end
  end

  def parse_code_block(text)
    text.gsub(/<p class="code">(.*?)<\/p>/i) do
      "<code>#{$1}</code>"
    end
  end

  def parse_quote_block(text)
    text.gsub(/<p class="quote">(.*?)<\/p>/i) do
      "<blockquote>#{$1}</blockquote>"
    end
  end

  def parse_paragraphs(text)
    text = text.gsub(/((?:\r?\n)+)/im) do
      "</p>\n\n<p>"
    end

    text = "<p>" + text unless text.start_with?("<p>")
    text += "</p>" unless text.end_with?("</p>")

    text
  end
end