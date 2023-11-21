# frozen_string_literal: true

require 'spec_helper'
require_relative '../lib/ls_command'
require_relative '../lib/ls_option'
require_relative '../lib/file_directory'

describe LsCommand do
  describe '#run_ls' do
    context 'when a option is given' do
      before do
        argv = ['-a', 'spec/fixtures/dummy_files']
        @ls_commnad = LsCommand.new(argv)
      end

      it 'has files including hidden files' do
        expect { @ls_commnad.run_ls }.to output(<<~HEREDOC).to_stdout
          .             dummy         dummy_1.txt#{'   '}
          ..            dummy2.txt    dummy_dir#{'     '}
        HEREDOC
      end
    end

    context 'when r option is given' do
      before do
        argv = ['-r', 'spec/fixtures/dummy_files']
        @ls_commnad = LsCommand.new(argv)
      end

      it 'has files including hidden files' do
        expect { @ls_commnad.run_ls }.to output(<<~HEREDOC).to_stdout
          dummy_dir     dummy2.txt#{'    '}
          dummy_1.txt   dummy#{'         '}
        HEREDOC
      end
    end

    context 'when l option is given' do
      before do
        argv = ['-l', 'spec/fixtures/dummy_files']
        @ls_commnad = LsCommand.new(argv)
      end

      it 'has files including hidden files' do
        expect { @ls_commnad.run_ls }.to output(<<~HEREDOC).to_stdout
          total 0
          -rw-r--r-- 1 shunhamm staff   0 11 17 10:18 dummy
          -rw-r--r-- 1 shunhamm staff   0 11 17 10:18 dummy2.txt
          -rw-r--r-- 1 shunhamm staff   0 11 17 10:18 dummy_1.txt
          drwxr-xr-x 2 shunhamm staff  64 11 17 10:18 dummy_dir
        HEREDOC
      end
    end
  end
end
