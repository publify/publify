require 'rails_helper'

describe 'Given an empty redirects table', type: :model do
  before(:each) do
    Redirect.delete_all
  end

  it 'redirects are unique' do
    expect { Redirect.create!(from_path: 'foo/bar', to_path: '/') }.not_to raise_error

    redirect = Redirect.new(from_path: 'foo/bar', to_path: '/')

    expect(redirect).not_to be_valid
    expect(redirect.errors[:from_path]).to eq(['has already been taken'])
  end
end
