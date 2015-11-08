class Search
  include ActiveModel::Model

  JSON_EVENT_FIELDS = [ 'actor', 'object', 'target' ]

  attr_accessor :project
  attr_reader :q, :name, :scope

  ### Main API

  def initialize_with_scope(attrs)
    @scope =
      (attrs[:project].try(:events) || Event.all).order("created_at DESC")
    initialize_without_scope(attrs)
  end
  alias_method_chain :initialize, :scope

  def results
    @scope
  end

  ### Attributes

  def q=(string_query)
    @q = string_query
    return if @q.nil?

    generated_query = ''
    tokens = StringParser.new(string_query).parsed_string
    tokens.each do |token|
      append_to_query(generated_query, token)
    end

    @scope = @scope.where(generated_query)
  end

  private

  def append_to_query(generated_query, token)
    if token == :or
      generated_query << ' OR '
    elsif token == :and
      generated_query << ' AND '

    # This looks dangerous but we know token is an array at this point
    # because the string parser would have raised an error otherwise
    elsif token.first == :group
      token.shift
      generated_query << '('
      token.each{ |sub_token| append_to_query(generated_query, sub_token) }
      generated_query << ')'

    elsif token.first == :equality
      token.shift

      fields = token.shift.split('.')
      if fields.length == 1
        columns = JSON_EVENT_FIELDS
      elsif fields.first == '*'
        fields.shift
        columns = JSON_EVENT_FIELDS
      else
        maybe_column = fields.shift
        if JSON_EVENT_FIELDS.include?(maybe_column)
          columns = [maybe_column]
        else
          columns = JSON_EVENT_FIELDS
        end
      end

      value = token.shift
      column_idx = 0
      while column_idx < columns.length
        column_name = columns[column_idx]
        generated_query <<
          " #{column_name} #> '{#{fields.join(',')}}' = '\"#{value}\"'"
        column_idx += 1
        generated_query << ' OR ' if column_idx < columns.length
      end
    end
  end
end
