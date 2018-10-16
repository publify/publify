# frozen_string_literal: true

module PublifyCore
  module TestingSupport
    module UploadFixtures
      module_function

      # Provide file upload helper for all specs
      def file_upload(file = 'testfile.txt', mime_type = 'text/plain')
        Rack::Test::UploadedFile.new(File.join(__dir__, 'fixtures', file),
                                     mime_type)
      end
    end
  end
end
