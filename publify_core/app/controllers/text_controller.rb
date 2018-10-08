# frozen_string_literal: true

class TextController < BaseController
  def humans
    render plain: this_blog.humans
  end

  def robots
    render plain: this_blog.robots
  end
end
