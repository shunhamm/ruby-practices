# frozen_string_literal: true

require_relative 'frame'

class Game
  NORMAL_FRAME_NUM = 9
  TOTAL_SHOTS_NUM_IN_NORMAL_FRAME = NORMAL_FRAME_NUM * 2
  MAX_SHOTS_NUM = NORMAL_FRAME_NUM * 2 + 3

  def initialize(result)
    @frames = build_frames(result)
  end

  def score
    game_score = 0
    @frames.first(NORMAL_FRAME_NUM).each_with_index do |frame, i|
      game_score += frame.shots_score_sum
      if frame.strike?
        game_score += Frame.strike_bonus_score_in_normal_frame(@frames[i + 1], @frames[i + 2])
      elsif frame.spare?
        game_score += Frame.spare_bonus_score_in_normal_frame(@frames[i + 1])
      end
    end
    # ファイナルフレームはストライク・スペアの有無に関わらずフレーム内の各投球スコアを足し上げたものと同じなのでボーナスの計算をしない
    game_score += @frames.last.shots_score_sum
    game_score
  end

  private

  def build_frames(result)
    marks = convert_result_to_marks(result)
    frames = []
    marks.first(TOTAL_SHOTS_NUM_IN_NORMAL_FRAME).each_slice(2) do |marks_by_frame|
      frames << Frame.new(*marks_by_frame)
    end
    # １０フレーム目をnew
    frames << if marks.length == MAX_SHOTS_NUM
                Frame.new(*marks.last(3))
              else
                Frame.new(*marks.last(2))
              end
    frames
  end

  def convert_result_to_marks(result)
    marks = result.split(',')
    new_marks = []
    shots_counter = 0 # １ショット毎に一つ加算する

    marks.each do |mark|
      if shots_counter >= TOTAL_SHOTS_NUM_IN_NORMAL_FRAME
        new_marks << mark
        shots_counter += 1
      elsif mark == 'X'
        new_marks << 'X'
        new_marks << '0'
        shots_counter += 2
      else
        new_marks << mark
        shots_counter += 1
      end
    end
    new_marks
  end
end
