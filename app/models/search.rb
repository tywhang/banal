class Search
  include ActiveModel::Model

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
    @scope = @scope.where(%(actor @> '{"name":"#{name}"}'))
  end

  def attributes=(attrs)
    attrs.each_pair {|method, value| send("#{method}=", value)}
  end
end
