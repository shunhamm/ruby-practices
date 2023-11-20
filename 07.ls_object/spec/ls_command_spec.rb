# frozen_string_literal: true

require 'spec_helper'
require_relative '../lib/ls_command'
require_relative '../lib/ls_option'
require_relative '../lib/path'

describe LsCommand do # rubocop:disable all
  describe '#show_ls' do # rubocop:disable all
    context 'when a option is given' do
      before do
        argv = ['-a', '07.ls_object/spec/fixtures/dummy_files']
        @ls_commnad = LsCommand.new(argv)
      end
      it 'has files including hidden files' do
        expect(@ls_commnad.show_ls).to be '.               ..              dummy           dummy2.txt      dummy_1.txt     dummy_dir'
      end
    end

    context 'when r option is given' do
      before do
        argv = ['-a', '07.ls_object/spec/fixtures/dummy_files']
        @ls_commnad = LsCommand.new(argv)
      end
      it 'has files including hidden files' do
        expect(@ls_commnad.show_ls).to be 'dummy_dir       dummy_1.txt     dummy2.txt      dummy'
      end
    end

    context 'when l option is given' do
      before do
        argv = ['-a', '07.ls_object/spec/fixtures/dummy_files']
        @ls_commnad = LsCommand.new(argv)
      end
      it 'has files including hidden files' do
        expect(@ls_commnad.show_ls).to be '
        total 0
-rw-r--r--@ 1 shunhamm  staff   0 11 17 10:18 dummy
-rw-r--r--@ 1 shunhamm  staff   0 11 17 10:18 dummy2.txt
-rw-r--r--@ 1 shunhamm  staff   0 11 17 10:18 dummy_1.txt
drwxr-xr-x@ 2 shunhamm  staff  64 11 17 10:18 dummy_dir
        '
      end
    end
  end
end
