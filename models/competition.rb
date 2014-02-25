require 'active_support/time'

class Competition < ActiveRecord::Base
  validates_presence_of :name,
                        :start_time,
                        :end_time,
                        :time_zone
  # many :teams

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
