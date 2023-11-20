# frozen_string_literal: true

class LsOption
  def initialize(args = ARGV)
    @options = {}
    parse(args)
  end

  def option_set?(option)
    !@options[option].nil?
  end

  private

  def parse(args)
    OptionParser.new do |opts|
      opts.on('-l') { @options['-l'] = true }
      opts.on('-a') { @options['-a'] = true }
      opts.on('-r') { @options['-r'] = true }
    end.parse(args)
  rescue OptionParser::InvalidOption => e
    raise e, '適切なオプションを指定して下さい。'
  end
end
