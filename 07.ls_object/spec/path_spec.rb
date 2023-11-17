# frozen_string_literal: true

require 'spec_helper'
require_relative '../lib/path'

describe Path do
  describe '#files' do
    context 'when path is available' do
      it 'returns the files' do
        path = Path.new
        expect(path.files).to eq(['dummy', 'dummy2.txt', 'dummy_1.txt', 'dummy_dir'])
      end
    end
  end
end
