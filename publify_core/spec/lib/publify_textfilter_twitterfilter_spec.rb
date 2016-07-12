require 'rails_helper'

describe PublifyApp::Textfilter::Twitterfilter do
  def filter_text(text, filters)
    TextFilter.filter_text(text, filters)
  end

  it 'should replace a hashtag with a proper URL to Twitter search' do
    text = filter_text('A test tweet with a #hashtag', [:twitterfilter])
    expect(text).to eq("A test tweet with a <a href='https://twitter.com/search?q=%23hashtag&src=tren&mode=realtime'>#hashtag</a>")
  end

  it 'should replace a @mention by a proper URL to the twitter account' do
    text = filter_text('A test tweet with a @mention', [:twitterfilter])
    expect(text).to eq("A test tweet with a <a href='https://twitter.com/mention'>@mention</a>")
  end

  it 'should replace a http URL by a proper link' do
    text = filter_text('A test tweet with a http://link.com', [:twitterfilter])
    expect(text).to eq("A test tweet with a <a href='http://link.com'>http://link.com</a>")
  end

  it 'should replace a https URL with a proper link' do
    text = filter_text('A test tweet with a https://link.com', [:twitterfilter])
    expect(text).to eq("A test tweet with a <a href='https://link.com'>https://link.com</a>")
  end

  it 'works with a hashtag and a mention' do
    text = filter_text('A test tweet with a #hashtag and a @mention', [:twitterfilter])
    expect(text).to eq("A test tweet with a <a href='https://twitter.com/search?q=%23hashtag&src=tren&mode=realtime'>#hashtag</a> and a <a href='https://twitter.com/mention'>@mention</a>")
  end
end

