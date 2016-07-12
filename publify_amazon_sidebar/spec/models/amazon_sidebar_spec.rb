require 'rails_helper'

describe 'Given a brand new AmazonSidebar', type: :model do
  before(:each) do
    @sidebar = AmazonSidebar.new
  end

  it "title should be 'Cited books'" do
    expect(@sidebar.title).to eq('Cited books')
  end

  it "associate_id should be 'justasummary-20'" do
    expect(@sidebar.associate_id).to eq('justasummary-20')
  end

  it 'maxlinks should be 4' do
    expect(@sidebar.maxlinks).to eq(4)
  end

  it "description should be 'Adds sidebar links...'" do
    expect(@sidebar.description).to eq(
      'Adds sidebar links to any Amazon.com books linked in the body of the page'
    )
  end

  it 'sidebar should be valid' do
    expect(@sidebar).to be_valid
  end
end

describe 'With no amazon sidebars', type: :model do
  it 'hash initialization should set attributes correctly' do
    sb = AmazonSidebar.new(title: 'Books',
                           associate_id: 'justasummary-21',
                           maxlinks: 3)
    expect(sb).to be_valid
    expect(sb.title).to eq('Books')
    expect(sb.associate_id).to eq('justasummary-21')
    expect(sb.maxlinks).to eq(3)
  end
end
