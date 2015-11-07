class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :rememberable, :trackable,
         :validatable

  has_many :memberships
  has_many :projects, through: :memberships

  after_create :add_demo_membership

  def name
    name = read_attribute('name')
    name.present? ? name : 'Anonymous'
  end

  private

  def add_demo_membership
    memberships.create(project: Project.demo)
  end
end
