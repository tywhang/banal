class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :rememberable, :trackable,
         :validatable

  has_many :memberships
  has_many :projects, through: :memberships
end
