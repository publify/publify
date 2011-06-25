# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
TypoBlog::Application.configure do
  config.secret_token = '40d432c8ee0935c62da0b2d251a03a358e3dfd9b30e1cb580e0edffebc153404d38e4c4f43623970eb7cf2fc3b99193f22ee6742a7d16a0c8fd2e4357489eb05';
end
