class User < ActiveRecord::Base
  validates :uid, presence: true

  def admin?
    self.admin
  end
end
