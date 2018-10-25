class Roll < ApplicationRecord
  belongs_to :frame

  validates_presence_of :pins, :frame
  validates_inclusion_of :pins, in: 0..10
end
