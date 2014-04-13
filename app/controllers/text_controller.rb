class TextController < ApplicationController
  def humans
    render text: this_blog.humans
  end
end
