require 'active_support/time'

class Competition < ActiveRecord::Base

  ##
  # name (String)
  #   an identifier for the competition
  validate :name, :presence => true

  ##
  # description (Text)
  #   information about the competition such as it's location
  #   or any restrictions/themes. rendered in markdown.

  ##
  # organizer (User)
  #   the person who is responsible for overseeing the
  #   competition. they are allowed to edit/delete the
  #   competition as well as broadcast updates to its
  #   participants.
  #
  #  foregin key: organizer_id
  belongs_to :organizer, :class_name => "User"

  ##
  # start_time (Time)
  #   the day and time when the competition starts, stored
  #   in UTC
  validate :start_time, :presence => true

  ##
  # end_time (Time)
  #   the day and time when the competition end, stored
  #   in UTC
  validate :end_time, :presence => true

  ##
  # time_zone (String)
  #   an ActiveSupport::TimeZone identifier to determine
  #   which time zone the competition is being held in
  validates :time_zone, :presence => true

  ##
  # teams ([Team])
  #   a collection of teams that are registered for the
  #   competition. a team can only be registered to one
  #   competition.
  has_many :teams, :inverse_of => :competition

  validate :end_time_is_greater_than_start_time

  def end_time_is_greater_than_start_time
    if end_time.to_i <= start_time.to_i
      errors.add(:end_time,
                 "The end time of the competition must be later than the start time.")
    end
  end

  def self.upcoming
    where("start_time > ?", Time.now)
  end

  def self.in_progress
    where("start_time <= ? AND end_time >= ?", Time.now, Time.now)
  end

  def self.passed
    where("end_time < ?", Time.now)
  end

  def self.upcoming_or_in_progress
    where("end_time > ?", Time.now)
  end

  def timezone
    @timezone ||= ActiveSupport::TimeZone.new(time_zone)
  end

  def start
    start_time.in_time_zone(timezone)
  end

  def end
    end_time.in_time_zone(timezone)
  end

  def formatted_start
    self.start.strftime('%A %B %-d, %Y %l:%M %P %Z')
  end

  def formatted_end
    self.end.strftime('%A %B %-d, %Y %l:%M %P %Z')
  end

  def passed?
    Time.now > end_time
  end

  def upcoming?
    Time.now < start_time
  end

  def in_progress?
    !(passed? || upcoming?)
  end
end
