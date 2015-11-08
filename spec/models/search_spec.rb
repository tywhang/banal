require 'rails_helper'

describe Search do
  let(:tom)   { create_event('Tom',   :post, "The Great Gatsby", 'Favorites') }
  let(:mark)  { create_event('Mark',  :post, "Game of Thrones", 'Favorites') }
  let(:jenny) { create_event('Jenny', :post, "Goodnight Moon", 'Favorites') }
  let(:patty) { create_event('Patty', :post, "Golf for Dummies", 'Favorites') }

  before do
    tom; mark; jenny; patty
  end

  context 'free text search' do
    it 'filters actor by name' do
      expect(search_for(q: "name:'Tom'")).to eq([tom])
    end

    it 'filters object by name' do
      expect(search_for(q: "name:'Game of Thrones'")).to eq([mark])
    end

    it 'filters target by name' do
      expect(search_for(q: "name:'Favorites'")).to eq([patty, jenny, mark, tom])
    end

    it 'filters by other fields' do
      expect(search_for(q: "fav_title:'Toms Favorites'")).to eq([tom])
    end
  end

  def search_for(attrs)
    described_class.new(attrs).results.to_a
  end

  def create_event(actor_name, verb, object_name, target_name = nil)
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
      project: stub_model(Project)
    )
  end
end
