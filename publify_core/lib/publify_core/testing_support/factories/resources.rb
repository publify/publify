FactoryBot.define do
  factory :resource do
    upload { PublifyCore::TestingSupport::UploadFixtures.file_upload }
    mime { "image/jpeg" }
    size { 110 }
    blog { Blog.first || create(:blog) }
  end

  factory :avatar, parent: :resource do
    upload { "avatar.jpg" }
    mime { "image/jpeg" }
    size { 600 }
  end
end
