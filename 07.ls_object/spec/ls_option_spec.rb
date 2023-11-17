# frozen_string_literal: true

require 'spec_helper'
require_relative '../lib/ls_option'

describe LsOption do # rubocop:disable all
  describe '#parse_options' do # rubocop:disable all
    context 'when no arguments are given' do
      before do
        @ls_option = LsOption.new([])
      end
      it 'has an empty options hash' do
        %w[-l -a -r].each do |option|
          expect(@ls_option.option_set?(option)).to be false
        end
      end
    end

    context 'when valid arguments are given' do
      before do
        args = ['-a', '-r', '-l']
        @ls_option = LsOption.new(args)
      end
      it 'has the options correctly' do
        %w[-l -a -r].each do |option|
          expect(@ls_option.option_set?(option)).to be true
        end
      end
    end

    context 'when invalid arguments are given' do
      it 'returns an error' do
        args = ['-x']
        expect { @ls_option = LsOption.new(args) }.to raise_error(OptionParser::InvalidOption)
      end
    end
  end
end
