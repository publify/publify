class ActiveSupport::SafeBuffer
  def concat(*args) super end
  alias << concat
end