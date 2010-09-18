require 'spec_helper'

describe AuthorsHelper, 'display_profile_item' do
  include AuthorsHelper

  it 'should display the item as a list item if show_item is true' do
    item = display_profile_item(item = 'my@jabber.org', show_item = true, item_desc = 'Jabber:')
    item.should have_selector('li', :content => 'Jabber: my@jabber.org')
  end

  it 'should NOT display the item as a list item if show_item is false' do
    item = display_profile_item(item = 'my@jabber.org', show_item = false, item_desc = 'Jabber:')
    item.should be_nil
  end

  it 'should display a link if the item is an url' do
    item = display_profile_item(item = 'http://twitter.com/mytwitter', show_item = true, item_desc = 'Twitter:')
    item.should have_selector('li') do
      have_selector('a', :content => 'http://twitter.com/mytwitter')
    end
  end

end
