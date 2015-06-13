require 'rails_helper'

describe 'Admin::TagsController routing', type: :routing do
  it 'routes #new' do
    expect(get: '/admin/tags/new').to route_to(controller: 'articles', action: 'redirect', from: 'admin/tags/new')
  end
  
  it 'routes #destroy' do
    expect(get: '/admin/tags/1/destroy').to route_to(controller: 'admin/tags', action: 'destroy', id: '1')
  end
  
  it 'routes #destroy' do
    expect(post: '/admin/tags/1/destroy').to route_to(controller: 'admin/tags', action: 'destroy', id: '1')
  end
end
