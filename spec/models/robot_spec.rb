require 'spec_helper'

describe Robot do
  describe :rules do
    it "read lines from robots.txt" do
      fake_lines = ['something', 'other']
      File.should_receive(:exists?).with(Robot::FILE).and_return(true)
      fake_file = double('fake_file')
      fake_file.should_receive(:readlines).and_return(fake_lines)
      File.should_receive(:new).with(Robot::FILE, 'r+').and_return(fake_file)

      expect(Robot.new.rules).to eq('somethingother')
    end
  end

  describe :add do
    it "if file is writable? then, add given lines" do
      new_lines = 'something: to add'
      File.should_receive(:writable?).with(Robot::FILE).and_return(true)
      File.should_receive(:exists?).with(Robot::FILE).and_return(true)
      fake_file = double('fake_file')
      File.should_receive(:new).with(Robot::FILE, 'r+').and_return(fake_file)
      fake_file.should_receive(:write).with(new_lines)
      fake_file.should_receive(:close)

      Robot.new.add(new_lines)
    end
  end
end

