# frozen_string_literal: true

class Path
  def initialize(path = nil)
    @path = path || '.'
  end

  def files
    Dir.entries(@path).sort
  rescue Errno::ENOENT => e
    raise e, "Path not found: #{@path}"
  end
end
