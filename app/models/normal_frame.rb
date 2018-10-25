class NormalFrame < Frame

  private

  def calculate_bonus
    if strike?
      strike_bonus
    elsif spare?
      spare_bonus
    else
      0
    end
  end

  def strike_bonus
    if next_frame.strike? && !next_frame.is_a?(LastFrame)
      next_frame.rolls[0].score + next_frame.next_frame.rolls[0]&.score.to_i
    elsif next_frame.strike? && next_frame.is_a?(LastFrame)
      next_frame.rolls[0].score + next_frame.rolls[1]&.score.to_i
    else
      next_frame.rolls.sum(&:score)
    end
  end

  def spare_bonus
    next_frame.rolls[0]&.score.to_i
  end
end
