require 'rails_helper'

describe Event do
  describe '#readonly?' do
    let(:created_event) do
      Event.create!(actor: { name: 'joe' },
                    verb: 'build',
                    object: { name: 'house' })
    end

    it 'is false for new records' do
      expect(Event.new.readonly?).to eq(false)
    end

    it 'is true for existing records' do
      expect(created_event.readonly?).to eq(true)
    end

    it 'cannot be deleted because of the readonly error' do
      expect{ created_event.destroy }.
        to raise_error(ActiveRecord::ReadOnlyRecord)
    end
  end
end
