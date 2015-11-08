require 'rails_helper'
require 'support/elasticsearch'

describe Search, elasticsearch: true do
  let(:tom)   { create_event('Tom',   :post, "The Great Gatsby", 'Favorites') }
  let(:mark)  { create_event('Mark',  :post, "Game of Thrones", 'Favorites') }
  let(:jenny) { create_event('Jenny', :post, "Goodnight Moon", 'Favorites') }
  let(:patty) { create_event('Patty', :post, "Golf for Dummies", 'Favorites') }

  let(:rick) { create_event('Rick', :add, "Go The F**k To Sleep", 'Favorites',
                            project: another_project) }

  let(:default_project) { stub_model(Project, id: 1) }
  let(:another_project) { stub_model(Project, id: 2) }

  let(:all_events) {
    [tom, mark, jenny, patty, rick].reverse
  }

  before do
    all_events
    Event.import(force: true, refresh: true)
  end

  context 'free text search' do
    it 'returns all results if no query given' do
      expect(search_for(q: "")).to eq(all_events)
    end

    it 'filters name generally' do
      expect(search_for(q: 'Tom')).to eq([tom])
      expect(search_for(q: 'Game of Thrones')).to eq([mark])
      expect(search_for(q: 'Favorites')).to eq(all_events)
    end

    it 'filters actor by name' do
      expect(search_for(q: 'actor.name:"Tom"')).to eq([tom])
    end

    it 'filters object by name' do
      expect(search_for(q: 'object.name:"Game of Thrones"')).to eq([mark])
    end

    it 'filters target by name' do
      expect(search_for(q: 'target.name:"Favorites"')).to eq(all_events)
    end

    it 'filters by other fields' do
      expect(search_for(q: 'fav_title:"Toms Favorites"')).to eq([tom])
    end

    it 'scopes by project.id if given a project' do
      expect(search_for(
        q: "", project: another_project
      )).to eq([rick])
    end
  end

  def search_for(attrs)
    described_class.new(attrs).results.to_a
  end

  def create_event(actor_name, verb, object_name, target_name = nil, project: nil)
    @id1 ||= 0
    @id1 += 1
    @id2 ||= 0
    @id2 += 1
    @id3 ||= 0
    @id3 += 1
    Event.create!(
      actor: {name: actor_name, id: @id1},
      verb: verb,
      object: {name: object_name, id: @id2},
      target: {name: target_name, id: @id3, actor_id: @id1,
               fav_title: "#{actor_name}s Favorites"},
      project: project || default_project
    )
  end
end
