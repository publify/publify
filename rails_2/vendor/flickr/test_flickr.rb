require 'flickr'
require 'test/unit'
#require 'stringio'

class MockFlickr < Flickr
  #@@data = eval(DATA.read)
  #def _get_response(url)
  #  raise "no data for #{url.inspect}" unless @@data.has_key? url 
  #  return REXML::Document.new(@@data[url])
  #end
end

class TestFlickr < Test::Unit::TestCase

  def setup
    @api_key = '86e18ef2a064ff2255845e029208d7f4'
    @email = 'sco@redgreenblu.com'
    @password = 'flickr.rb'
    @username = 'flickr.rb'
    @user_id = '35034359890@N01'
    @photo_id = '8649502'
    @tag = 'onetag'
    @tags = 'onetag twotag'
    @tag_id = '27359619'
    @date_posted = '2005-01-01 16:01:26'
    @dates = '1093566950'
    @group_id = '37718676860@N01'
    @group_url = 'http://flickr.com/groups/kansascity/'
    @user_url = 'http://flickr.com/photos/sco/'
    @title = 'New Set'
    @f = MockFlickr.new
    @f.login(@email, @password)
    @u = @f.users(@email)
  end
  

  ##### DIRECT MODE

  def test_test_echo
    assert_equal @f.test_echo['stat'], 'ok'
  end
  def test_test_login
    assert_equal @f.test_login['stat'], 'ok'
  end

  
  ##### BASICS

  def test_request
    assert_equal @f.request('test.echo')['stat'], 'ok'
  end

  def test_request_url
    assert_equal "http://flickr.com/services/rest/?api_key=#{@api_key}&method=flickr.test.echo&foo=bar&email=#{@email}&password=#{@password}", @f.request_url('test.echo', ['foo'=>'bar'])
  end

  def test_login
    assert_equal @username, @f.user.getInfo.username
  end

  def test_find_by_url
    assert_equal @group_id, @f.find_by_url(@group_url).getInfo.id     # find group by URL
    assert_equal @user_id, @f.find_by_url(@user_url).getInfo.id       # find user by URL
  end

  def test_photos
    assert_equal 100, @f.photos.size                                              # find recent
    assert_equal @user_id, @f.photos('user_id'=>@user_id).first.getInfo.owner.id  # search by user_id
  end

  def test_users
    assert_equal @username, @f.users(@email).getInfo.username     # find by email
    assert_equal @username, @f.users(@username).getInfo.username  # find by username
    assert_kind_of Flickr::User, @f.users.first                   # find all online users
  end

  def test_groups
    assert_kind_of Flickr::Group, @f.groups.first                   # find all active groups
  end

  def test_licenses
    assert_kind_of Array, @f.licenses                   # find all licenses
  end


  ##### USER

  def test_getInfo
    @u.getInfo
    assert_equal @username, @u.username
  end

  def test_groups
    assert_kind_of Flickr::Group, @u.groups.first                   # public groups
  end

  def test_photos
    assert_kind_of Flickr::Photo, @u.photos.first                   # public photos
  end

  def test_contacts
    assert_kind_of Flickr::User, @u.contacts.first                   # public contacts
  end

  def test_favorites
    assert_kind_of Flickr::Photo, @u.favorites.first                 # public favorites
  end

  def test_photosets
    assert_kind_of Flickr::Photoset, @u.photosets.first              # public photosets
  end

  def test_tags
    assert_kind_of Array, @u.tags                                    # tags
  end

  def test_contactsPhotos
    assert_kind_of Flickr::Photo, @u.contactsPhotos.first            # contacts' favorites
  end


  ##### PHOTO

  def test_getInfo
    @p.getInfo
    assert_equal @photo_id, @p.id
  end


  ##### PHOTOSETS
  
  #def setup
  #  super
  #  @photoset = @f.photosets_create('title'=>@title, 'primary_photo_id'=>@photo_id)
  #  @photoset_id = @photoset['photoset']['id']
  #end
  #def teardown
  #  @f.photosets_delete('photoset_id'=>@photoset_id)
  #end

  def test_photosets_editMeta
    assert_equal @f.photosets_editMeta('photoset_id'=>@photoset_id, 'title'=>@title)['stat'], 'ok'
  end

  def test_photosets_editPhotos
    assert_equal @f.photosets_editPhotos('photoset_id'=>@photoset_id, 'primary_photo_id'=>@photo_id, 'photo_ids'=>@photo_id)['stat'], 'ok'
  end

  def test_photosets_getContext
    assert_equal @f.photosets_getContext('photoset_id'=>@photoset_id, 'photo_id'=>@photo_id)['stat'], 'ok'
  end

  def test_photosets_getContext
    assert_equal @f.photosets_getContext('photoset_id'=>@photoset_id, 'photo_id'=>@photo_id)['stat'], 'ok'
  end

  def test_photosets_getInfo
    assert_equal @f.photosets_getInfo('photoset_id'=>@photoset_id)['stat'], 'ok'
  end

  def test_photosets_getList
    assert_equal @f.photosets_getList['stat'], 'ok'
  end

  def test_photosets_getPhotos
    assert_equal @f.photosets_getPhotos('photoset_id'=>@photoset_id)['stat'], 'ok'
  end

  def test_photosets_orderSets
    assert_equal @f.photosets_orderSets('photoset_ids'=>@photoset_id)['stat'], 'ok'
  end

end