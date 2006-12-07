require File.dirname(__FILE__) + '/../spec_helper'

context 'With the resource fixtures loaded and their equivalent files in place on the disk' do
  fixtures(:resources)

  setup do
     FileUtils.mkpath(RAILS_ROOT + '/public/files')
    Resource.find(:all).each {|f| FileUtils.touch(f.fullpath)}
  end

  teardown do
    [:resource1, :resource2, :resource3].each do |sym|
      res = resources(sym)
      File.unlink(res.fullpath) if File.exist?(res.fullpath)
    end
  end

  specify 'there are three resources in the database' do
    Resource.count.should == 3
  end

  specify 'fullpath should be RAILS_ROOT + "/public/files/" + resource.filename' do
    res = Resource.new(:article_id => 1, :filename => 'a_new_file', :mime => 'image/jpeg', :size => 110)
    res.fullpath.should == RAILS_ROOT + "/public/files/a_new_file"
  end

  specify 'resources created with the same name as an existing resource don\'t overwrite the old resource' do
    resources(:resource1).should_not_be_nil
    f1 = Resource.create(:filename => resources(:resource1).filename,
                         :mime => resources(:resource1).mime)
    f1.should_not_be_nil
    f1.should_be_valid

    f1.filename.should_not == resources(:resource1).filename
    f1.destroy
  end

  specify 'a resource deletes its associated file on destruction' do
    File.exist?(RAILS_ROOT + '/public/files/me.jpg').should_be true
    Resource.destroy(1)
    File.exist?(RAILS_ROOT + '/public/files/me.jpg').should_be false
  end
end
