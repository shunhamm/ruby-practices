# frozen_string_literal: true

class Path
  def initialize(argv = nil)
    @path = argv || '.'
  end

  def files
    Dir.entries(@path).sort
  rescue Errno::ENOENT => e
    raise e, "Path not found: #{@path}"
  end
end
