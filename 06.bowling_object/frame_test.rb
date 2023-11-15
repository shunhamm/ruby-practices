# frozen_string_literal: true

require_relative 'frame'
require_relative 'shot'
require 'minitest/autorun'

class FrameTest < Minitest::Test
  def test_score
    frame1 = Frame.new('1', '2')
    assert_equal 3, frame1.score

    frame2 = Frame.new('7', '3')
    assert_equal 10, frame2.score

    frame3 = Frame.new('X')
    assert_equal 10, frame3.score

    frame4 = Frame.new('X', 'X', 'X')
    assert_equal 30, frame4.score
  end
end
