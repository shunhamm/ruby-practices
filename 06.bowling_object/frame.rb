# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :first_shot, :second_shot

  def initialize(first_mark, second_mark = nil, third_mark = nil)
    @first_shot = Shot.new(first_mark)
    @second_shot = Shot.new(second_mark)
    @third_shot = Shot.new(third_mark) unless third_mark.nil?
  end

  def strike?
    @first_shot.mark == 'X'
  end

  def spare?
    !strike? && [@first_shot.score, @second_shot.score].sum == 10
  end

  def score
    return [@first_shot.score, @second_shot.score, @third_shot.score].sum if @third_shot

    [@first_shot.score, @second_shot.score].sum
  end

  def self.strike_bonus_score(next_frame, following_frame = nil)
    if next_frame.first_shot.mark == 'X' && following_frame
      next_frame.first_shot.score + next_frame.second_shot.score + following_frame.first_shot.score
    else
      next_frame.first_shot.score + next_frame.second_shot.score
    end
  end

  def self.spare_bonus_score(next_frame)
    next_frame.first_shot.score
  end
end
