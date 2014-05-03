class TextController < ApplicationController
  def humans
    render text: this_blog.humans
  end

  def robots
    render text: this_blog.robots
  end
end
