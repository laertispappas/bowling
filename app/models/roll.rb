class Roll < ApplicationRecord
  belongs_to :frame

  default_scope { order(id: :asc) }

  validates_presence_of :pins, :frame
  validates_inclusion_of :pins, in: 0..10

  def score
    pins
  end
end
