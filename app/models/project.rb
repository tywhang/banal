class Project < ActiveRecord::Base
  DEMO_NAME = 'Demo Project'

  has_many :memberships
  has_many :users, through: :memberships
  has_many :events

  validates :name, presence: true
  validates :token, presence: true, length: { minimum: 32 }, uniqueness: true

  before_validation :set_token_on_create

  def self.demo
    Project.find_by!(name: DEMO_NAME)
  end

  def track_event(actor, verb, object, target = nil)
    Event.create!(
      project: self,
      actor: actor,
      verb: verb,
      object: object,
      target: target
    )
  end

  private

  def set_token_on_create
    self.token = SecureRandom.urlsafe_base64(32).downcase if new_record?
  end
end
