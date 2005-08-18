require File.dirname(__FILE__) + '/../test_helper'

class ResourceTest < Test::Unit::TestCase
  fixtures :resources

  def setup
    @resource = Resource.find(1)
    @resource2 = Resource.find(2)
    
    # put the files on disk as if it were uploaded 
    FileUtils.mkpath("#{RAILS_ROOT}/public/files")
    [ @resource, @resource2 ].each { |f| FileUtils.touch(f.fullpath) }
  end

  def teardown
    # remove the files on disk
    [ @resource, @resource2 ].each { |f| 
      File.unlink(f.fullpath) if File.exist?(f.fullpath) 
    }
  end
  
  def test_fullpath
    assert_equal @resource.fullpath, "#{RAILS_ROOT}/public/files/#{@resource.filename}"
  end
  
  def test_create
    assert_not_nil @resource
    assert_not_nil @resource2

    f1 = Resource.create(:filename => @resource['filename'],
                            :mime => @resource['mime'],
                            :created_at => Time.now)
    assert_not_nil f1
    f2 = Resource.create(:filename => @resource2['filename'],
                            :mime => @resource2['mime'],
                            :created_at => Time.now)
    assert_not_nil f2

    assert @resource.filename != f1.filename
    assert @resource2.filename != f2.filename
    f1.destroy
    f2.destroy
  end

  def test_read
    assert_not_nil @resource
    f = Resource.find_by_filename(@resources['resource1']['filename'])
    assert_not_nil f
    assert_equal f, @resource
  end
  
  def test_update
    assert_not_nil @resource
    assert_not_nil @resource2
    
    f = @resources['resource2']
    assert @resource2.save
    assert_equal f["filename"], @resource2.filename

    @resource.filename = f['filename']
    assert !@resource.save

    @resource.filename = Resource.find(1).filename
    assert @resource.save
  end

  def test_destroy
    assert_not_nil @resource
    # blow it away, ensure that the file is removed from the public/files dir
    assert @resource.destroy
    assert !File.exist?(@resource.fullpath)
    assert_raise(ActiveRecord::RecordNotFound) { Resource.find(@resource.id) }
  end
end
