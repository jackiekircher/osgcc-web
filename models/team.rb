class Team
  include MongoMapper::Document

  key :name,           String,  :required => true
  key :user_ids,       Array,   :default => []
  key :competition_id, Integer, :required => true

  belongs_to :competition
  many       :users, :in => :user_ids, :class_name => "User"

  timestamps!

  validate :cannot_have_more_members_than_limit

  TEAM_LIMIT = 3

  def cannot_have_more_members_than_limit
    if users.length > TEAM_LIMIT
      errors.add(:users, "Teams cannot have more than #{TEAM_LIMIT} members.")
    end
  end

  def member?(user)
    return users.include? user
  end

  def full?
    return users.count >= TEAM_LIMIT
  end
end
