# frozen_string_literal: true

class TextController < BaseController
  def robots
    render plain: this_blog.robots
  end
end
