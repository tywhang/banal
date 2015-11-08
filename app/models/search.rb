class Search
  include ActiveModel::Model

  PER_PAGE = 50

  attr_accessor :project, :q
  attr_reader :parsed_q

  ### Main API

  def results
    Event.search(full_query).records
  end

  def full_query
    {}.tap do |query|
      if q.present?
        query[:filter] = {query: {query_string: {query: q}}}
      else
        query[:query] = {match_all: {}}
      end

      if project.present?
        query[:filter] ||= {}
        query[:filter][:term] = {project_id: project.id}
      end

      query[:sort] = [{created_at: 'desc'}]
      query[:size] = PER_PAGE
    end
  end

  ### Attributes

  def q=(string_query)
    @q = string_query
    @parsed_q = string_query.present? ? string_query : '*'
  end
end
