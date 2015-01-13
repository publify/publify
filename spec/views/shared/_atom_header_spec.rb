require 'rails_helper'

describe 'shared/_atom_header.atom.builder', type: :view do
  let!(:blog) { create :blog }

  describe 'with no items' do
    it 'shows publify with the current version as the generator' do
      xml = ::Builder::XmlMarkup.new
      xml.foo do
        render partial: 'shared/atom_header',
               formats: [:atom], handlers: [:builder],
               locals: { feed: xml, items: [] }
      end

      assert_correct_atom_generator xml.target!
    end
  end
end
