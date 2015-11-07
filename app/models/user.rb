class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :rememberable, :trackable,
         :validatable

  has_many :memberships
  has_many :projects, through: :memberships

  def name
    name = read_attribute['name']
    name.present? ? name : 'Anonymous'
  end
end
