# frozen_string_literal: true

namespace :demo do
  # Based on https://stackoverflow.com/questions/28515857/reset-database-with-rake-task/28516002#28516002
  desc "Reset demo data"
  task reset: :environment do
    # Destroy all regular models
    ActiveRecord::Base.connection.tables.each do |table|
      table.singularize.camelize.constantize.destroy_all
    rescue NameError
      puts "Class for #{table} not found; Skipping ..."
    end

    # Destroy sessions. For this model, the model class cannot be determined
    # from the table name.
    ActiveRecord::SessionStore::Session.destroy_all

    Rails.application.load_seed

    text_filter = "markdown"
    strong_password = "FOO!@123bar"
    admin_password = "admin123"
    publisher_password = "demo1234"

    # Create admin user
    user = User.create!(name: "Admin",
                        login: "admin",
                        email: "admin@example.com",
                        password: strong_password,
                        text_filter_name: text_filter)

    # Use simple but bad password for the demo
    user.password = admin_password
    user.save(validate: false)

    blog = Blog.first
    blog.update!(base_url: ENV["BASE_URL"].to_s,
                 blog_name: "Publify Demo")

    # Create default first article
    blog.articles.build(title: I18n.t("setup.article.title"),
                        author: user.login,
                        body: I18n.t("setup.article.body"),
                        allow_comments: 1,
                        allow_pings: 1,
                        user: user).publish!

    publisher = User.create!(email: "demo@example.com",
                             login: "demo",
                             name: "Demo Publisher",
                             password: strong_password,
                             text_filter_name: text_filter,
                             profile: "publisher")

    # Use simple but bad password for the demo
    publisher.password = publisher_password
    publisher.save(validate: false)
  end
end
