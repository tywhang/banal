require 'rails_helper'

describe Search do
  let(:tom)   { create_event('Tom',   :post, "The Great Gatsby", 'Favorites') }
  let(:mark)  { create_event('Mark',  :post, "Game of Thrones", 'Favorites') }
  let(:jenny) { create_event('Jenny', :post, "Goodnight Moon", 'Favorites') }
  let(:patty) { create_event('Patty', :post, "Golf for Dummies", 'Favorites') }

  let(:rick) { create_event('Rick', :post, "Go The F**k To Sleep", 'Favorites', project: project_b) }

  let(:project_a) { stub_model(Project, id: 1) }
  let(:project_b) { stub_model(Project, id: 2) }

  before do
    tom; mark; jenny; patty; rick
  end

  context 'free text search' do
    it 'returns all results if no query given' do
      expect(search_for(q: "")).to eq([patty, jenny, mark, tom])
    end

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

    it 'scopes by project.id if given a project' do
      expect(search_for(
        q: "", project: project_b
      )).to eq([tom])
    end
  end

  def search_for(attrs)
    byebug
    described_class.new(attrs).results.to_a
  end

  def create_event(actor_name, verb, object_name, target_name = nil, project:nil)
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
      project: project || project_a
    )
  end
end
