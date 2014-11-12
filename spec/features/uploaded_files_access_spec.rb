feature 'Uploaded files access' do
  background do
    create(:blog)
  end

  scenario 'when user is not an admin' do
    visit admin_ckeditor.attachment_files_path

    expect(current_path).to eq('/accounts/signup')
  end

  scenario 'when user is an admin' do
    sign_in(:as_admin)
    visit admin_ckeditor.attachment_files_path

    expect(current_path).to eq(admin_ckeditor.attachment_files_path)
  end

  scenario 'when user is a publisher' do
    sign_in(:as_publisher)
    visit admin_ckeditor.attachment_files_path

    expect(current_path).to eq(admin_ckeditor.attachment_files_path)
  end

  scenario 'when user is a contributor' do
    sign_in(:as_publisher)
    visit admin_ckeditor.attachment_files_path

    expect(current_path).to eq(admin_ckeditor.attachment_files_path)
  end
end
