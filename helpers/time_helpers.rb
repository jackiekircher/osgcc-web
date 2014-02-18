module TimeHelpers

  def date_of(datetime)
    return datetime.strftime('%F')
  end

  def time_of(datetime)
    return datetime.strftime('%H:%M')
  end
end
