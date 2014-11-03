module SessionHelpers
  def sign_in
    user = build(:user, :as_admin)
    password = user.password
    user.save

    visit accounts_path

    fill_in 'user_login', with: user.login
    fill_in 'user_password', with: password
    click_button 'Sign in'
  end
end
