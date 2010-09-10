module Admin::UsersHelper
  def get_select(needle, haystack)
    return 'selected="selected"' if needle.to_s == haystack.to_s
  end

  def render_options_for_display_name
    options = "<option value='#{@user.login}' #{get_select(@user.name, @user.login)}>#{@user.login}</option>"
    options << "<option value='#{@user.nickname}' #{get_select(@user.name, @user.nickname)}>#{@user.nickname}</option>" unless @user.nickname.nil?
    options << "<option value='#{@user.firstname}' #{get_select(@user.name, @user.firstname)}>#{@user.firstname}</option>" unless @user.firstname.nil?
    options << "<option value='#{@user.lastname}' #{get_select(@user.name, @user.lastname)}>#{@user.lastname}</option>" unless @user.lastname.nil?
    options << "<option value='#{@user.firstname} #{@user.lastname}' #{get_select(@user.name, @user.firstname + @user.lastname)}>#{@user.firstname} #{@user.lastname}</option>" unless (@user.firstname.nil? or @user.lastname.nil?)
    return options
  end
end
