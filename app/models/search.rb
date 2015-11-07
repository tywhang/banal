class Search
  include ActiveModel::Model

  JSON_EVENT_FIELDS = [ 'actor', 'object', 'target' ]

  attr_accessor :project
  attr_reader :q, :name, :scope

  ### Main API

  def initialize_with_scope(attrs)
    @scope =
      (attrs[:project].try(:events) || Event.all).
      order("created_at DESC").limit(50)
    initialize_without_scope(attrs)
  end
  alias_method_chain :initialize, :scope

  def results
    @scope
  end

  ### Attributes

  def q=(string_query)
    @q = string_query
    return if string_query.blank?

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
