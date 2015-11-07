class Project < ActiveRecord::Base
  validates :name, presence: true
  validates :token, presence: true, length: { minimum: 32 }, uniqueness: true

  before_validation :set_token_on_create

  private

  def set_token_on_create
    self.token = SecureRandom.urlsafe_base64(32).downcase if new_record?
  end
end
