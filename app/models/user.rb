class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :rememberable, :trackable,
         :validatable

  has_many :memberships
  has_many :projects, through: :memberships

  def name_with_anonymous
    name_without_anonymoust.present? ? name_without_anonymous : 'Anonymous'
  end
  alias_method_chain :name, :anonymous
end
