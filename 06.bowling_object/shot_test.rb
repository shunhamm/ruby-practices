# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'shot'

class ShotTest < Minitest::Test
  def test_score
    shot1 = Shot.new('1')
    assert_equal 1, shot1.score

    shot2 = Shot.new('X')
    assert_equal 10, shot2.score
  end
end
