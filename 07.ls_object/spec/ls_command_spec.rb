# frozen_string_literal: true

require 'spec_helper'
require_relative '../lib/ls_command'
require_relative '../lib/ls_option'
require_relative '../lib/file_directory'

describe LsCommand do # rubocop:disable all
  # テスト環境に合わせてfile_statusを動的に取得する必要があればここに記載する
  def file_metadata_for_test(file_path)
    stat = File.stat(file_path)
    owner_name = Etc.getpwuid(stat.uid).name
    group_name = Etc.getgrgid(stat.gid).name
    { owner: owner_name, group: group_name }
  end

  describe '#run_ls' do # rubocop:disable all
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

      it 'shows file names which sorted by reverse' do
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
        @metadata = file_metadata_for_test('spec/fixtures/dummy_files/dummy')
      end

      it 'shows file names with file details' do
        expect { @ls_commnad.run_ls }.to output(<<~HEREDOC).to_stdout
          total 0
          -rw-r--r-- 1 #{@metadata[:owner]} #{@metadata[:group]}   0 11 17 10:18 dummy
          -rw-r--r-- 1 #{@metadata[:owner]} #{@metadata[:group]}   0 11 17 10:18 dummy2.txt
          -rw-r--r-- 1 #{@metadata[:owner]} #{@metadata[:group]}   0 11 17 10:18 dummy_1.txt
          drwxr-xr-x 2 #{@metadata[:owner]} #{@metadata[:group]}  64 11 17 10:18 dummy_dir
        HEREDOC
      end
    end

    context 'when [l, a, r] options are given' do
      before do
        argv = ['-lar', 'spec/fixtures/dummy_files']
        @ls_commnad = LsCommand.new(argv)
        @metadata = file_metadata_for_test('spec/fixtures/dummy_files/dummy')
      end

      it 'shows file names, including hidden files, sorted in reverse order with file details.' do
        expect { @ls_commnad.run_ls }.to output(<<~HEREDOC).to_stdout
          total 0
          drwxr-xr-x 2 #{@metadata[:owner]} #{@metadata[:group]}   64 11 17 10:18 dummy_dir
          -rw-r--r-- 1 #{@metadata[:owner]} #{@metadata[:group]}    0 11 17 10:18 dummy_1.txt
          -rw-r--r-- 1 #{@metadata[:owner]} #{@metadata[:group]}    0 11 17 10:18 dummy2.txt
          -rw-r--r-- 1 #{@metadata[:owner]} #{@metadata[:group]}    0 11 17 10:18 dummy
          drwxr-xr-x 3 #{@metadata[:owner]} #{@metadata[:group]}   96 11 17 10:18 ..
          drwxr-xr-x 6 #{@metadata[:owner]} #{@metadata[:group]}  192 11 17 10:20 .
        HEREDOC
      end
    end

    context 'when any option is not given' do
      before do
        argv = ['spec/fixtures/dummy_files']
        @ls_commnad = LsCommand.new(argv)
      end

      it 'shows file names by default sort' do
        expect { @ls_commnad.run_ls }.to output(<<~HEREDOC).to_stdout
          dummy         dummy_1.txt#{'   '}
          dummy2.txt    dummy_dir#{'     '}
        HEREDOC
      end
    end
  end
end
