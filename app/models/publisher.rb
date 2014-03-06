class Publisher
  def initialize(user)
    @user = user
  end

  def new_note
    Note.new do |note|
      note.author = @user
      note.text_filter = @user.text_filter
    end
  end
end
