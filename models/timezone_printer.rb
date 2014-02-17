require 'tzinfo'

class TimezonePrinter

  FILTER_LIST = [
                  'Pacific/Midway',
                  'US/Hawaii',
                  'US/Alaska',
                  'US/Pacific',
                  'US/Mountain',
                  'US/Central',
                  'US/Eastern',
                  'Canada/Newfoundland',
                  'Canada/Atlantic',
                  'Brazil/West',
                  'Brazil/East',
                  'Greenwich',
                  'Europe/London',
                  'Europe/Paris',
                  'Europe/Kaliningrad',
                  'Asia/Baghdad',
                  'Asia/Muscat',
                  'Asia/Tehran',
                  'Asia/Karachi',
                  'Asia/Calcutta',
                  'Asia/Kathmandu',
                  'Asia/Almaty',
                  'Asia/Bangkok',
                  'Asia/Hong_Kong',
                  'Asia/Tokyo',
                  'Australia/West',
                  'Australia/Adelaide',
                  'Australia/Sydney',
                  'Pacific/Auckland'
                ]

  def self.filtered_list
    FILTER_LIST.map{ |t| TimezonePrinter.new(TZInfo::Timezone.get(t)) }
  end

  def self.unique_list
    TZInfo::Timezone.all.uniq{ |t| t.strftime("%Z") }
  end

  def initialize(timezone)
    @zone = timezone
  end

  def identifier
    @zone.identifier
  end

  def abbr
    @zone.strftime("%Z")
  end

  def name
    @zone.friendly_identifier
  end

  def offset
    offset  = @zone.current_period.utc_total_offset
    minutes = (offset/60) % 60
    hours   = (offset/3600).abs
    sign    = (offset > 0) ? "+" : "-"
    "#{sign}#{"%02d" % hours}:#{"%02d" % minutes}"
  end

  def to_option
    "[ #{abbr} #{offset} ] #{name}"
  end

  def to_local(time)
    @zone.utc_to_local(time).strftime('%A %B %-d, %Y %l:%M %P ') + abbr
  end

  def to_date(time)
    @zone.utc_to_local(time).strftime('%F')
  end

  def to_time(time)
    @zone.utc_to_local(time).strftime('%H:%M')
  end
end
