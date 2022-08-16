# frozen_string_literal: true

class Ping < ApplicationRecord
  include StringLengthLimit

  belongs_to :article
  validates_default_string_length :url
end
