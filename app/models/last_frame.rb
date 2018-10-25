class LastFrame < Frame
  MAX_ROLLS_COUNT = 3

  def active?
    return rolls.size < MAX_ROLLS_COUNT if strike? || spare?

    more_rolls?
  end

  private

  def calculate_bonus
    0
  end
end
