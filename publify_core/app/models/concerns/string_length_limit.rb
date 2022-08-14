# frozen_string_literal: true

module StringLengthLimit
  # Default string length limit for model attributes. When running on MySQL,
  # this is equal to the default string length in the database as set by Rails.
  STRING_LIMIT = 255

  extend ActiveSupport::Concern

  class_methods do
    def validates_default_string_length(*names)
      names.each do |name|
        validates name, length: { maximum: STRING_LIMIT }
      end
    end
  end
end
