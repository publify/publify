class Redirect < ActiveRecord::Base
  validates :from_path, uniqueness: true
  validates :to_path, presence: true

  has_many :redirections

  has_many :contents, through: :redirections

  def full_to_path
    path = to_path
    return path if path =~ /^(https?):\/\/([^\/]*)(.*)/
    url_root = Blog.default.root_path
    path = File.join(url_root, path) unless url_root.nil? || path[0, url_root.length] == url_root
    path
  end

  def shorten
    if (temp_token = random_token) && self.class.find_by_from_path(temp_token).nil?
      return temp_token
    else
      shorten
    end
  end

  def to_url
    File.join(((Blog.default.custom_url_shortener.nil? || Blog.default.custom_url_shortener.empty?) ? Blog.default.base_url : Blog.default.custom_url_shortener), from_path)
  end

  private

  def random_token
    characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890'
    temp_token = ''
    srand
    6.times do
      pos = rand(characters.length)
      temp_token += characters[pos..pos]
    end
    temp_token
  end
end
