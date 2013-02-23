module Admin::UsersHelper
  def get_select(needle, haystack)
    return 'selected="selected"' if needle.to_s == haystack.to_s
  end

  def render_options_for_display_name
    options = "<option value='#{@user.login}' #{get_select(@user.name, @user.login)}>#{@user.login}</option>"
    options << "<option value='#{@user.nickname}' #{get_select(@user.name, @user.nickname)}>#{@user.nickname}</option>" unless @user.nickname.blank?
    options << "<option value='#{@user.firstname}' #{get_select(@user.name, @user.firstname)}>#{@user.firstname}</option>" unless @user.firstname.blank?
    options << "<option value='#{@user.lastname}' #{get_select(@user.name, @user.lastname)}>#{@user.lastname}</option>" unless @user.lastname.blank?
    options << "<option value='#{@user.firstname} #{@user.lastname}' #{get_select(@user.name, @user.firstname + @user.lastname)}>#{@user.firstname} #{@user.lastname}</option>" unless (@user.firstname.blank? or @user.lastname.blank?)
    return options
  end
end
