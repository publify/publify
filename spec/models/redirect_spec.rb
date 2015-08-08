require 'rails_helper'

describe 'Given an empty redirects table', type: :model do
  let(:blog) { create(:blog) }

  it 'redirects are unique' do
    expect { blog.redirects.create!(from_path: 'foo/bar', to_path: '/') }.not_to raise_error

    redirect = blog.redirects.new(from_path: 'foo/bar', to_path: '/')

    expect(redirect).not_to be_valid
    expect(redirect.errors[:from_path]).to eq(['has already been taken'])
  end
end
