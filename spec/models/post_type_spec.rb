# coding: utf-8
require 'rails_helper'

describe PostType, type: :model do
  before(:each) do
    FactoryGirl.create(:blog)
  end

  describe 'Given a new post type' do
    it 'should give a valid post type' do
      expect(PostType.create(name: 'foo')).to be_valid
    end

    it 'should have a sanitized permalink' do
      @pt = PostType.create(name: 'Un joli PostType Accentué')
      expect(@pt.permalink).to eq('un-joli-posttype-accentue')
    end

    it 'should have a sanitized permalink with a' do
      @pt = PostType.create(name: 'Un joli PostType à Accentuer')
      expect(@pt.permalink).to eq('un-joli-posttype-a-accentuer')
    end
  end

  it 'post types are unique' do
    expect { PostType.create!(name: 'test') }.not_to raise_error
    test_type = PostType.new(name: 'test')
    expect(test_type).not_to be_valid
    expect(test_type.errors[:name]).to eq(['has already been taken'])
  end
end
