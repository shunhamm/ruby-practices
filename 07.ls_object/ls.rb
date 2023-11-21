# frozen_string_literal: true

require_relative 'lib/ls_command'

def main
  ls = LsCommand.new(ARGV)
  ls.run_ls
end

main
