module Localization
  mattr_accessor :lang

  @@l10s = { :default => {} }
  @@lang = :default

  def self._(string_to_localize, *args)
    translated = @@l10s[@@lang][string_to_localize]
    translated = string_to_localize if translated == "" or translated.nil?

    return translated.call(*args).to_s  if translated.is_a? Proc

    if translated.is_a? Array
      translated = if translated.size == 3
        translated[args[0]==0 ? 0 : (args[0]>1 ? 2 : 1)]
      else
        translated[args[0]>1 ? 1 : 0]
      end
    end
    sprintf translated, *args
  end

  def self.__(string_to_localize, *args)
    translated = @@l10s[@@lang][string_to_localize]
    translated = string_to_localize if translated == "" or translated.nil?

    return translated.call(*args).to_s  if translated.is_a? Proc

    if translated.is_a? Array
      translated = if translated.size == 3
        translated[args[0]==0 ? 0 : (args[0]>1 ? 2 : 1)]
      else
        translated[args[0]>1 ? 1 : 0]
      end
    end
    translated
  end

  def self.define(lang = :default)
    @@l10s[lang] ||= {}
    yield @@l10s[lang]
  end

  def self.load
    Dir.glob("#{::Rails.root.to_s}/lang/*.rb"){ |t| require t }
    Dir.glob("#{::Rails.root.to_s}/lang/custom/*.rb"){ |t| require t }
  end

  # Generates a best-estimate l10n file from all views by
  # collecting calls to _() -- note: use the generated file only
  # as a start (this method is only guesstimating)
  def self.generate_l10n_file
    "Localization.define('en_US') do |l|\n" <<
    Dir.glob("#{::Rails.root.to_s}/app/views/**/*.rhtml").collect do |f|
      ["# #{f}"] << File.read(f).scan(/<%.*[^\w]_\s*[\"\'](.*?)[\"\']/)
    end.uniq.flatten.collect do |g|
      g.starts_with?('#') ? "\n  #{g}" : "  l.store '#{g}', '#{g}'"
    end.uniq.join("\n") << "\nend"
  end

end

class Object
  def _(*args); Localization._(*args); end
  def __(*args); Localization.__(*args); end
end
