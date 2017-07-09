require 'rails_helper'

RSpec.describe 'xml_sidebar/_content.html.erb', type: :view do
  let(:sidebar) { XmlSidebar.new }

  it 'renders an XML sidebar' do
    render partial: sidebar.content_partial, locals: sidebar.to_locals_hash
  end
end
