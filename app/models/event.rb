class Event < ActiveRecord::Base
  validates :actor, presence: true
  validates :verb, presence: true
  validates :object, presence: true

  # Force this model to be readonly.
  before_destroy { |record| raise ActiveRecord::ReadOnlyRecord }

  def readonly?
    !new_record?
  end
end
