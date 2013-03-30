class Admin::TokenChecker
  DEFAULT_TOKEN = "08aac1f2d29e54c90efa24a4aefef843ab62da7a2610d193bc0558a50254c7debac56b48ffd0b5990d6ed0cbecc7dc08dce1503b6b864d580758c3c46056729a"

  attr_reader :file

  def initialize(file = File.join(Rails.root, "config", "secret.token"))
    @file = file
  end

  def safe_token_in_use?
    TypoBlog::Application.config.secret_token != DEFAULT_TOKEN
  end

  def needs_token_generation?
    File.read(@file).chomp == DEFAULT_TOKEN
  end

  def generate_token
    if needs_token_generation?
      length = DEFAULT_TOKEN.length / 2
      File.write(@file, "#{SecureRandom.hex(length)}\n")
    end
  end
end
