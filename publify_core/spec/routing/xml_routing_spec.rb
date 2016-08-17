require 'rails_helper'

describe XmlController, type: :routing do
  describe 'routing' do
    it 'recognizes and generates #articlerss' do
      expect(get: '/xml/articlerss/1/feed.xml').to route_to(controller: 'xml', action: 'articlerss', id: '1')
    end

    it 'recognizes and generates #commentrss' do
      expect(get: '/xml/commentrss/feed.xml').to route_to(controller: 'xml', action: 'commentrss')
    end

    it 'recognizes and generates #trackbackrss' do
      expect(get: '/xml/trackbackrss/feed.xml').to route_to(controller: 'xml', action: 'trackbackrss')
    end

    it 'recognizes and generates #rsd' do
      expect(get: '/xml/rsd').to route_to(controller: 'xml', action: 'rsd')
    end

    it 'recognizes and generates #feed' do
      expect(get: '/xml/atom/feed.xml').to route_to(controller: 'xml', action: 'feed', type: 'feed', format: 'atom')
    end

    it 'recognizes and generates #feed with a custom type' do
      expect(get: '/xml/atom/comments/feed.xml').to route_to(controller: 'xml', action: 'feed', format: 'atom', type: 'comments')
    end

    it 'recognizes and generates #feed with a custom type and an id' do
      expect(get: '/xml/atom/comments/1/feed.xml').to route_to(controller: 'xml', action: 'feed', format: 'atom', type: 'comments', id: '1')
    end

    it 'recognizes and generates #feed with rss type' do
      expect(get: '/xml/rss').to route_to(controller: 'xml', action: 'feed', type: 'feed', format: 'rss')
    end

    it 'recognizes and generates #feed without format' do
      expect(get: '/xml/feed').to route_to(controller: 'xml', action: 'feed')
    end

    it 'recognizes and generates #feed with sitemap type' do
      expect(get: '/sitemap.xml').to route_to(controller: 'xml', action: 'feed', type: 'sitemap', format: 'googlesitemap')
    end
  end
end
