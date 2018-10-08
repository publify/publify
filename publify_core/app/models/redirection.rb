# frozen_string_literal: true

class Redirection < ApplicationRecord
  belongs_to :content
  belongs_to :redirect
end
