class Team < ActiveRecord::Base

  ##
  # name (String)
  #   an identifier for the team
  validates :name, :presence => true

  ##
  # competition (Competition)
  #   the competition that the team is associated with.
  #   a team may only be associated with one competition.
  #
  #   foreign key: competition_id
  belongs_to :competition,    :inverse_of => :teams
  validates  :competition_id, :presence => true

  ##
  # members ([Users])
  #   a collection of users that have joined the team.
  #   users may join many teams, even teams associated with
  #   the same competiton
  #
  #   linked through joins table teams_users
  #
  has_and_belongs_to_many :members, :class_name => "User"

  validate :cannot_have_more_members_than_limit


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

  def remove_member(user)
    members.delete(user)
  end
end
