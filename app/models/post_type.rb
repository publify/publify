class PostType < ActiveRecord::Base
  validates_uniqueness_of :name
  validates_presence_of :name
  validate :name_is_not_read
  before_save :sanitize_title
  
  
  def name_is_not_read
      errors.add(:name, _("This article type already exists")) if name == 'read'
  end
  
  accents = { ['á','à','â','ä','ã','Ã','Ä','Â','À'] => 'a',
    ['é','è','ê','ë','Ë','É','È','Ê'] => 'e',
    ['í','ì','î','ï','I','Î','Ì'] => 'i',
    ['ó','ò','ô','ö','õ','Õ','Ö','Ô','Ò'] => 'o',
    ['œ'] => 'oe',
    ['ß'] => 'ss',
    ['ú','ù','û','ü','U','Û','Ù'] => 'u',
    ['ç','Ç'] => 'c'
  }

  FROM, TO = accents.inject(['','']) { |o,(k,v)|
    o[0] << k * '';
    o[1] << v * k.size
    o
  }

  def sanitize_title
    self.permalink = self.name.tr(FROM, TO).gsub(/<[^>]*>/, '').to_url
  end
end