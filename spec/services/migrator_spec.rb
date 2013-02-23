require 'spec_helper'

describe Migrator do
  let(:migrator) { Migrator.new }
  let(:migrations_path) { Rails.root + 'db' + 'migrate' }

  describe "#current_schema_version" do
    it "delegates to ActiveRecord::Migrator" do
      ActiveRecord::Migrator.should_receive(:current_version).and_return "the-current-version"
      migrator.current_schema_version.should eq "the-current-version"
    end
  end

  describe "#pending_migrations" do
    it "asks ActiveRecord::Migrator to look up pending migrations in db/migrate" do
      ar_migrator = double("activerecord migrator")
      ar_migrator.should_receive(:pending_migrations).and_return ['a_migration', 'another_migration']

      ActiveRecord::Migrator.should_receive(:new).with(:up, migrations_path).and_return ar_migrator

      migrator.pending_migrations.should eq ['a_migration', 'another_migration']
    end
  end

  describe "#migrations_pending?" do
    before do
      ar_migrator = double("activerecord migrator")
      ar_migrator.should_receive(:pending_migrations).and_return pending_migrations

      ActiveRecord::Migrator.should_receive(:new).with(:up, migrations_path).and_return ar_migrator
    end

    context "when there are pending migrations" do
      let(:pending_migrations) { ['a_migration', 'another_migration'] }
      it "returns true" do
        migrator.migrations_pending?.should be_true
      end
    end

    context "when there are no pending migrations" do
      let(:pending_migrations) { [] }
      it "returns false" do
        migrator.migrations_pending?.should be_false
      end
    end
  end

  describe "#migrate" do
    it "delegates to ActiveRecord::Migrator" do
      ActiveRecord::Migrator.should_receive(:migrate).with(migrations_path)
      migrator.migrate
    end
  end
end
