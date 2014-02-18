require 'active_support/time'

class Competition
  include MongoMapper::Document

  key :name,       String, :required => true
  key :start_time, Time,   :required => true
  key :end_time,   Time,   :required => true
  key :time_zone,  String, :required => true

  many :teams

  timestamps!

  def self.upcoming
    Competition.where(:start_time.gt => Time.now)
  end

  def self.in_progress
    Competition.where(:start_time.lte => Time.now,
                      :end_time.gte   => Time.now)
  end

  def self.passed
    Competition.where(:end_time.lt => Time.now)
  end

  def self.upcoming_or_in_progress
    Competition.where(:end_time.gt => Time.now)
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
    return Time.now > end_time
  end

  def upcoming?
    return Time.now < start_time
  end

  def in_progress?
    return !(passed? || upcoming?)
  end
end
