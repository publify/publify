module SessionHelpers
  def sign_in(user_type = :as_admin)
    user = build(:user, user_type)
    password = user.password
    user.save

    visit accounts_path

    fill_in 'user_login', with: user.login
    fill_in 'user_password', with: password
    click_button 'Sign in'
  end
end
