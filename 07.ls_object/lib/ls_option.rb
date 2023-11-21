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

  # ユーザー引数を解析し、lsコマンドのオプションが含まれる場合の処理を行う
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
    raise e, '無効なオプションです。使用可能なオプション: -l, -a, -r'
  end
end
