# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
TypoBlog::Application.initialize!

ENV['RECAPTCHA_PUBLIC_KEY']  = '6LdyTL0SAAAAAKX9s7SW_3gIYRKScBv9CCR8HO0f'
ENV['RECAPTCHA_PRIVATE_KEY'] = '6LdyTL0SAAAAAOESIwbJKtWEYkPkw6WOHC2K7zqw'