require 'rails_helper'

describe 'An API user' do
  include RSpec::Rails::RequestExampleGroup

  describe 'creating an event' do
    let(:project) { Project.create!(name: Faker::Company.name) }
    let(:attrs) do
      {
        'actor'  => '{ "name": "tom" }',
        'verb'   => 'buy',
        'object' => '{ "name": "stuff" }'
      }
    end

    def create_event
      put '/api/events',
        attrs.to_json,
        { 'CONTENT_TYPE' => 'application/json',
          'ACCEPT'       => 'application/json',
          'X-AUTHTOKEN'  => project.token }
    end

    it 'succeeds with status 201' do
      create_event
      expect(response.status).to equal(201)
    end

    it 'creates a new event' do
      expect { create_event }.to change { Event.count }.by(1)
      event = Event.last
      expect(event.actor).to eql({ "name" => "tom" })
      expect(event.verb).to eql('buy')
      expect(event.object).to eql({ "name" => "stuff" })
    end
  end
end

