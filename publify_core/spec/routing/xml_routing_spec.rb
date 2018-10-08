# frozen_string_literal: true

require 'rails_helper'

describe XmlController, type: :routing do
  describe 'routing' do
    it 'recognizes and generates #feed with sitemap type' do
      expect(get: '/sitemap.xml').to route_to(controller: 'xml', action: 'sitemap', format: 'googlesitemap')
    end
  end
end
