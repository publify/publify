class PageCache < ActiveRecord::Base
  cattr_accessor :public_path
  @@public_path = ActionController::Base.page_cache_directory

  def self.sweep_all
    self.zap_pages('index.*', 'articles', 'pages')
  end

  def self.zap_pages(*paths)
    trash = Dir::tmpdir
    FileUtils.makedirs(trash)
    srcs = paths.collect { |v|
      Dir.glob(public_path + "/#{v}")
    }
    FileUtils.mv(srcs.flatten, trash, :force => true)
    FileUtils.rm_rf(trash)
  end
end
