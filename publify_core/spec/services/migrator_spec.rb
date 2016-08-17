require 'rails_helper'

describe Migrator do
  let(:migrator) { Migrator.new }
  let(:migrations_paths) { ['db/migrate'] }
  let(:all_migrations) { ActiveRecord::Migrator.migrations(migrations_paths) }

  describe '#current_schema_version' do
    it 'delegates to ActiveRecord::Migrator' do
      expect(ActiveRecord::Migrator).to receive(:current_version).and_return 'the-current-version'
      expect(migrator.current_schema_version).to eq 'the-current-version'
    end
  end

  describe '#pending_migrations' do
    it 'asks ActiveRecord::Migrator to look up pending migrations in db/migrate' do
      ar_migrator = double('activerecord migrator')
      expect(ar_migrator).to receive(:pending_migrations).and_return %w(a_migration another_migration)

      expect(ActiveRecord::Migrator).to receive(:new).with(:up, all_migrations).and_return ar_migrator

      expect(migrator.pending_migrations).to eq %w(a_migration another_migration)
    end
  end

  describe '#migrations_pending?' do
    before do
      ar_migrator = double('activerecord migrator')
      expect(ar_migrator).to receive(:pending_migrations).and_return pending_migrations

      expect(ActiveRecord::Migrator).to receive(:new).with(:up, all_migrations).and_return ar_migrator
    end

    context 'when there are pending migrations' do
      let(:pending_migrations) { %w(a_migration another_migration) }
      it 'returns true' do
        expect(migrator.migrations_pending?).to be_truthy
      end
    end

    context 'when there are no pending migrations' do
      let(:pending_migrations) { [] }
      it 'returns false' do
        expect(migrator.migrations_pending?).to be_falsey
      end
    end
  end

  describe '#migrate' do
    it 'delegates to ActiveRecord::Migrator' do
      expect(ActiveRecord::Migrator).to receive(:migrate).with(migrations_paths)
      migrator.migrate
    end
  end
end
