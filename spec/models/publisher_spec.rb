require 'rails_helper'

describe Publisher, type: :model do
  context 'with a user' do
    let(:user) { create(:user) }

    let(:publisher) { Publisher.new(user) }

    describe '#new_note' do
      it { expect(publisher.new_note).to be_a(Note) }
      it { expect(publisher.new_note.author).to eq(user.login) }
      it { expect(publisher.new_note.text_filter).to eq(user.text_filter) }
    end
  end
end
