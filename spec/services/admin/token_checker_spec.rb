require 'rails_helper'

describe Admin::TokenChecker do
  let(:fixture) { Rails.root.join('spec', 'fixtures', 'secret.token') }
  let(:checker) { Admin::TokenChecker.new(fixture) }

  describe '#safe_token_in_use?' do
    it 'returns false with the default token loaded' do
      Publify::Application.config.secret_key_base = $default_token
      expect(checker.safe_token_in_use?).to be_falsey
    end

    it 'returns true with some other token loaded' do
      Publify::Application.config.secret_key_base = 'foo'
      expect(checker.safe_token_in_use?).to be_truthy
    end
  end

  describe '#needs_token_generation?' do
    it 'returns true with the default token in the config' do
      File.write(fixture, "#{$default_token}\n")
      expect(checker.needs_token_generation?).to be_truthy
    end

    it 'returns false if a token has already been generated' do
      File.write(fixture, "foo\n")
      expect(checker.needs_token_generation?).to be_falsey
    end
  end

  describe '#generate_token' do
    before do
      File.write(fixture, "#{$default_token}\n")
    end

    it 'stores a new token in the token file' do
      checker.generate_token
      result = File.read(fixture).chomp
      expect(result).not_to eq 'existing-token'
    end

    it 'creates a token of the same length as the default token' do
      checker.generate_token
      result = File.read(fixture).chomp
      expect(result.length).to eq $default_token.length
    end

    it 'does not generate a new token if the current one is safe' do
      checker.generate_token
      first_token = File.read(fixture).chomp
      checker.generate_token
      second_token = File.read(fixture).chomp
      expect(second_token).to eq first_token
    end

    it 'returns true on success' do
      rval = checker.generate_token
      expect(rval).to be_truthy
    end

    it 'propagates errors on failure' do
      File.chmod(0444, fixture)
      expect { checker.generate_token }.to raise_error
    end
  end

  after do
    File.delete fixture if File.exist? fixture
  end
end
