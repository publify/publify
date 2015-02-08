require 'rails_helper'

describe 'Given a new StaticSidebar', type: :model do
  before(:each) { @sb = StaticSidebar.new }

  it 'title should be Links' do
    expect(@sb.title).to eq('Links')
  end

  it 'body should be our default' do
    expect(@sb.body).to eq(StaticSidebar::DEFAULT_TEXT)
  end

  it 'description should be set correctly' do
    expect(@sb.description).to eq('Static content, like links to other sites, advertisements, or blog meta-information')
  end
end
