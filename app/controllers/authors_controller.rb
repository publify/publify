class AuthorsController < ContentController
  layout :theme_layout
  
  def show
    @author = User.find_by_login(params[:id])
  end
end