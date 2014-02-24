class Team < ActiveRecord::Base
  validates :name, :competition_id, presence: true
  validate  :cannot_have_more_members_than_limit

  belongs_to :competition, inverse_of: :teams
  has_and_belongs_to_many :members, class_name: "User"

  TEAM_LIMIT = 3

  def cannot_have_more_members_than_limit
    if members.length > TEAM_LIMIT
      errors.add(:members, "Teams cannot have more than #{TEAM_LIMIT} members.")
    end
  end

  def member?(user)
    members.include? user
  end

  def full?
    members.length >= TEAM_LIMIT
  end

  def add_member(user)
    return false if full?

    members << user
    return true
  end
end
