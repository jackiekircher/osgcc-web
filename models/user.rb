class User < ActiveRecord::Base
  validates :uid, presence: true

  has_and_belongs_to_many :teams

  def admin?
    self.admin
  end
end
