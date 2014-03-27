class Team < ActiveRecord::Base

  ##
  # name (String)
  #   an identifier for the team
  validates :name,
            :presence => true,
            :uniqueness => { :scope => :competition_id }

  ##
  # competition (Competition)
  #   the competition that the team is associated with.
  #   a team may only be associated with one competition.
  #
  #   foreign key: competition_id
  belongs_to :competition,    :inverse_of => :teams
  validates  :competition_id, :presence => true

  ##
  # repository_url (String)
  #   each team will have one repository linked to it that
  #   contains their submission. team members may coordinate
  #   through local copies or push to multiple repos during
  #   the competition but only submissions to the repository
  #   designated by this string will count.

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
  validate :members_must_be_unique

  TEAM_LIMIT = 3

  def cannot_have_more_members_than_limit
    if members.length > TEAM_LIMIT
      errors.add(:members, "Teams cannot have more than #{TEAM_LIMIT} members.")
    end
  end

  def members_must_be_unique
    if members.uniq.length != members.length
      errors.add(:members, "Team members must be different people.")
    end
  end

  def member?(user)
    members.include? user
  end

  def full?
    members.length >= TEAM_LIMIT
  end

  def joinable?(user)
    !self.member?(user) && !self.full?
  end

  def add_member(user)
    return false unless joinable?(user)

    members << user
    return true
  end

  def remove_member(user)
    members.delete(user)
  end

  def show_repo?
    !repository_url.blank?
  end
end
