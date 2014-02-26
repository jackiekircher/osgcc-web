class User < ActiveRecord::Base
  validates_presence_of :uid

  has_and_belongs_to_many :teams

  def admin?
    self.admin
  end
end
