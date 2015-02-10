class Admin::TokenChecker
  attr_reader :file

  def initialize(file = File.join(Rails.root, 'config', 'secret.token'))
    @file = file
  end

  def safe_token_in_use?
    Publify::Application.config.secret_key_base != $default_token
  end

  def needs_token_generation?
    return true unless File.exist? file
    File.read(@file).chomp == $default_token
  end

  def generate_token
    if needs_token_generation?
      length = $default_token.length / 2
      File.write(@file, "#{SecureRandom.hex(length)}\n")
    end
  end
end
