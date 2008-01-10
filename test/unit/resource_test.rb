require File.dirname(__FILE__) + '/../test_helper'

class ResourceTest < Test::Unit::TestCase
  def setup
    # put the files on disk as if it were uploaded
    FileUtils.mkpath("#{RAILS_ROOT}/public/files")
    [ resources(:resource1), resources(:resource2) ].each { |f| FileUtils.touch(f.fullpath) }
  end

  def teardown
    # remove the files on disk
    [ resources(:resource1), resources(:resource2) ].each { |f|
      File.unlink(f.fullpath) if File.exist?(f.fullpath)
    }
  end

  def test_fullpath
    assert_equal resources(:resource1).fullpath, "#{RAILS_ROOT}/public/files/#{resources(:resource1).filename}"
  end

  def test_create
    assert_not_nil resources(:resource1)
    assert_not_nil resources(:resource2)

    f1 = Resource.create(:filename => resources(:resource1).filename,
                            :mime => resources(:resource1).mime,
                            :created_at => Time.now)
    assert_not_nil f1
    f2 = Resource.create(:filename => resources(:resource2).filename,
                            :mime => resources(:resource2).mime,
                            :created_at => Time.now)
    assert_not_nil f2

    assert resources(:resource1).filename != f1.filename
    assert resources(:resource2).filename != f2.filename
    f1.destroy
    f2.destroy
  end

  def test_read
    assert_not_nil resources(:resource1)
    f = Resource.find_by_filename(resources(:resource1).filename)
    assert_not_nil f
    assert_equal f, resources(:resource1)
  end

  def test_update
    assert_not_nil resources(:resource1)
    assert_not_nil resources(:resource2)

    f = resources(:resource2)
    assert resources(:resource2).save
    assert_equal f.filename, resources(:resource2).filename

    resources(:resource1).filename = f.filename
    assert !resources(:resource1).save

    resources(:resource1).filename = Resource.find(resources(:resource1).id).filename
    assert resources(:resource1).save
  end

  def test_destroy
    assert_not_nil resources(:resource1)
    # blow it away, ensure that the file is removed from the public/files dir
    assert resources(:resource1).destroy
    assert !File.exist?(resources(:resource1).fullpath)
    assert_raise(ActiveRecord::RecordNotFound) { Resource.find(resources(:resource1).id) }
  end
end
