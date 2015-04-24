require 'rails_helper'

describe 'Admin::PagesController routing', type: :routing do
  it 'routes #new' do
    expect(get: '/admin/pages/new').to route_to(controller: 'admin/pages', action: 'new')
  end
  
  it 'routes #destroy' do
    expect(get: '/admin/pages/1/destroy').to route_to(controller: 'admin/pages', action: 'destroy', id: '1')
  end
  
  it 'routes #destroy' do
    expect(post: '/admin/pages/1/destroy').to route_to(controller: 'admin/pages', action: 'destroy', id: '1')
  end
end
