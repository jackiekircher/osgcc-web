module CompetitionHelpers

  def matches_timezone?(competition, zone)
    competition.timezone == zone
  end
end

class OSGCCWeb
  helpers CompetitionHelpers
end
