# frozen_string_literal: true

require 'spec_helper'
require_relative '../lib/path'

describe Path do
  describe '#files' do
    context 'when path is available' do
      it 'returns the files' do
        path = Path.new('./spec/fixtures/dummy_files')
        expect(path.files).to eq(['.', '..', 'dummy', 'dummy2.txt', 'dummy_1.txt', 'dummy_dir'])
      end
    end

    context 'when path is not available' do
      it 'raises an error' do
        path = Path.new('./spec/fixtures/dammy_files')
        expect { path.files }.to raise_error(Errno::ENOENT)
      end
    end
  end
end
