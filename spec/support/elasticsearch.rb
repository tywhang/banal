RSpec.configure do |config|
  # Snipped other config.
  config.before :each, elasticsearch: true do
    Event.__elasticsearch__.create_index! index: Event.index_name
  end

  config.after :each, elasticsearch: true do
    Event.__elasticsearch__.client.indices.delete index: Event.index_name
  end
end
