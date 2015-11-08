class Event < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  index_name [Rails.env, model_name.collection.gsub(/\//, '-')].join('_')

  belongs_to :project

  validates :actor, presence: true
  validates :verb, presence: true
  validates :object, presence: true
  validates :project, presence: true

  # Force this model to be readonly.
  before_destroy { |record| raise ActiveRecord::ReadOnlyRecord }

  def readonly?
    !new_record?
  end
end
