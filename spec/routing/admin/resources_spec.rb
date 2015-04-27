require 'rails_helper'

describe 'Admin::ResourcesController routing', type: :routing do
  it 'routes #destroy' do
    expect(get: '/admin/resources/1/destroy').to route_to(controller: 'admin/resources', action: 'destroy', id: '1')
  end
  
  it 'routes #destroy' do
    expect(post: '/admin/resources/1/destroy').to route_to(controller: 'admin/resources', action: 'destroy', id: '1')
  end
end
