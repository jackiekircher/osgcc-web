module DisplayHelpers

  def escape_html(content)
    Rack::Utils.escape_html(content)
  end
end

class OSGCCWeb
  helpers DisplayHelpers
end
