# frozen_string_literal: true

require 'optparse'

class LsOption
  def initialize(args)
    @options = {}
    parse(args) unless args.empty?
  end

  def option_set?(option)
    !@options[option].nil?
  end

  private

  def parse(args)
    options_to_set = {
      '-l' => 'l',
      '-a' => 'a',
      '-r' => 'r'
    }

    OptionParser.new do |opts|
      options_to_set.each do |flag, option|
        opts.on(flag) { @options[option] = true }
      end
    end.parse!(args)
  rescue OptionParser::InvalidOption => e
    raise e, '適切なオプションを指定して下さい。'
  end
end
