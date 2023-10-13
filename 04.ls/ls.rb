# frozen_string_literal: true

require_relative 'ls_methods'
require 'optparse'

def main
  option = {}
  opt = OptionParser.new

  opt.on('-r') { |v| option[:r] = v }

  opt.parse!(ARGV)
  # ARGV[0]にpathの入力値が渡される。ファイル名を渡すことは出来ない。
  path = ARGV[0].nil? ? '.' : ARGV[0]
  contents = get_files(path)
  transformed_contents = transform_with_ls_option(contents, option)
  show(transformed_contents)
end

main
