class Event < ActiveRecord::Base
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
