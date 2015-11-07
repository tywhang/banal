class Search
  include ActiveModel::Model

  JSON_EVENT_FIELDS = [ 'actor', 'object', 'target' ]

  attr_reader :q, :name, :scope

  ### Main API

  def initialize_with_scope(attrs)
    @scope = Event.all
    initialize_without_scope(attrs)
  end
  alias_method_chain :initialize, :scope

  def results
    @scope
  end

  ### Attributes

  def q=(string_query)
    @q = string_query
    self.attributes = StringParser.new(string_query).to_attrs
  end

  def name=(name)
    @name = name
    search_string = ""
    JSON_EVENT_FIELDS.each do |field|
      search_string += " OR " unless search_string.blank?
      search_string += %(#{field} @> '{"name":"#{name}"}')
    end
    @scope = @scope.where(search_string)
  end

  def attributes=(attrs)
    attrs.each_pair {|method, value| send("#{method}=", value)}
  end
end
