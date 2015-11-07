require 'rails_helper'

describe Search::StringParser do
  it 'parses a quoted name from a string' do
    expect(parse("name='Tom'")).to include(name: 'Tom')
    expect(parse("name:'Tom'")).to include(name: 'Tom')
  end

  def parse(str)
    described_class.new(str).to_attrs
  end
end
