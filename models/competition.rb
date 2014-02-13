class Competition
  include MongoMapper::Document

  key :name,          String, :required => true
  key :start_date,    Time
  key :end_date,      Time
  key :tz_identifier, String

  many :teams

  timestamps!

  def self.upcoming
    Competition.where(:start_date.gt => Time.now)
  end

  def self.in_progress
    Competition.where(:start_date.lte => Time.now,
                      :end_date.gte   => Time.now)
  end

  def self.passed
    Competition.where(:end_date.lt => Time.now)
  end

  def self.upcoming_or_in_progress
    Competition.where(:end_date.gt => Time.now)
  end

  def timezone
    TZInfo::Timezone.get(tz_identifier)
  end

  def formatted_start
    TimezonePrinter.new(timezone).to_local(start_date)
  end

  def formatted_end
    TimezonePrinter.new(timezone).to_local(end_date)
  end

  def passed?
    return DateTime.now > end_date
  end

  def upcoming?
    return DateTime.now < start_date
  end

  def in_progress?
    return !(passed? || upcoming?)
  end
end
