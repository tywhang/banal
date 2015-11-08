class Search
  include ActiveModel::Model

  JSON_EVENT_FIELDS = [ 'actor', 'object', 'target' ]

  attr_accessor :project, :q
  attr_reader :parsed_q

  ### Main API

  def results
    Event.search(full_query).records
  end

  def full_query
    {}.tap do |query|
      if q.present?
        query.merge!(query: {query_string: {query: q}})
      else
        query.merge!(query: {match_all: {}})
      end

      if project.present?
        query.merge!(filter: {term: {project_id: project.id}})
      end
    end
  end

  ### Attributes

  def q=(string_query)
    @q = string_query
    @parsed_q = string_query.present? ? string_query : '*'
  end
end
