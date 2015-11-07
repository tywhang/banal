require 'rails_helper'

describe 'An API user' do
  include RSpec::Rails::RequestExampleGroup

  describe 'creating an event' do
    let(:attrs) do
      {
        'actor'  => { 'name' => 'tom' },
        'verb'   => 'buy',
        'object' => { 'name' => 'stuff' }
      }
    end

    def create_event
      put '/api/events',
        attrs.to_json,
        { 'CONTENT_TYPE' => 'application/json',
          'ACCEPT'       => 'application/json' }
    end

    it 'succeeds with status 200' do
      create_event
      expect(response.status).to equal(201)
    end

    it 'creates a new event' do
      expect { create_event }.to change { Event.count }.by(1)
      event = Event.last
      expect(event).to have_attributes(attrs)
    end
  end
end

