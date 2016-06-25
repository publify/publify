require 'rails_helper'

describe 'Given a brand new AmazonSidebar', type: :model do
  before(:each) do
    @sidebar = Sidebar.new(type: 'AmazonSidebar')
    @config = @sidebar.configuration
  end

  it "title should be 'Cited books'" do
    expect(@config.title).to eq('Cited books')
  end

  it "associate_id should be 'justasummary-20'" do
    expect(@config.associate_id).to eq('justasummary-20')
  end

  it 'maxlinks should be 4' do
    expect(@config.maxlinks).to eq(4)
  end

  it "description should be 'Adds sidebar links...'" do
    expect(@config.description).to eq(
      'Adds sidebar links to any Amazon.com books linked in the body of the page'
    )
  end

  it 'sidebar should be valid' do
    expect(@sidebar).to be_valid
  end
end

describe 'With no amazon sidebars', type: :model do
  it 'hash initialization should set attributes correctly' do
    sb = Sidebar.new(type: 'AmazonSidebar',
                           config: { 'title' => 'Books',
                                     'associate_id' => 'justasummary-21',
                                     'maxlinks' => 3 })
    conf = sb.configuration
    expect(sb).to be_valid
    expect(conf.title).to eq('Books')
    expect(conf.associate_id).to eq('justasummary-21')
    expect(conf.maxlinks).to eq(3)
  end
end
