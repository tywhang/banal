class Event < ActiveRecord::Base
  validates :actor, presence: true
  validates :verb, presence: true
  validates :object, presence: true
end
