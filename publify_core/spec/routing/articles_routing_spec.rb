require 'rails_helper'

describe ArticlesController, type: :routing do
  describe 'routing' do
    it 'recognizes and generates #index' do
      expect(get: '/').to route_to(controller: 'articles', action: 'index')
    end

    it 'recognizes and generates #index with rss format' do
      expect(get: '/articles.rss').to route_to(controller: 'articles', action: 'index', format: 'rss')
    end

    it 'recognizes and generates #index with atom format' do
      expect(get: '/articles.atom').to route_to(controller: 'articles', action: 'index', format: 'atom')
    end
  end

  describe 'routing for #redirect action' do
    it 'picks up any previously undefined path' do
      expect(get: '/foobar').to route_to(controller: 'articles',
                                         action: 'redirect',
                                         from: 'foobar')
    end

    it 'matches paths with multiple components' do
      expect(get: 'foo/bar/baz').to route_to(controller: 'articles',
                                             action: 'redirect',
                                             from: 'foo/bar/baz')
    end

    it 'should route URLs under /articles' do
      expect(get: '/articles').to route_to(controller: 'articles',
                                           action: 'redirect',
                                           from: 'articles')
      expect(get: '/articles/foo').to route_to(controller: 'articles',
                                               action: 'redirect',
                                               from: 'articles/foo')
      expect(get: '/articles/foo/bar').to route_to(controller: 'articles',
                                                   action: 'redirect',
                                                   from: 'articles/foo/bar')
      expect(get: '/articles/foo/bar/baz').to route_to(controller: 'articles',
                                                       action: 'redirect',
                                                       from: 'articles/foo/bar/baz')
    end
  end
end
