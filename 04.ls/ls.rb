#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'ls_methods'
require 'optparse'

def main
  option = {}
  opt = OptionParser.new

  opt.on('-a') { |v| option[:a] = v }
  opt.on('-r') { |v| option[:r] = v }
  opt.on('-l') { |v| option[:l] = v }
  opt.parse!(ARGV)
  path = ARGV[0].nil? ? '.' : ARGV[0]
  files = files(path)
  new_files = transform_by_option(files, option, path)

  if option[:l]
    puts "total #{new_files[0]}"
    new_files[1..].each { |files| puts files }
  else
    show_as_grid(new_files)
  end
end
main
