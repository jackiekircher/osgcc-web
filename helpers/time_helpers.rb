module TimeHelpers

  def formatted_date(time)
    time.strftime('%A %B %-d, %Y %l:%M %P %Z')
  end

  def date_of(time)
    time.strftime('%F')
  end

  def time_of(time)
    time.strftime('%H:%M')
  end
end

class OSGCCWeb
  helpers TimeHelpers
end
