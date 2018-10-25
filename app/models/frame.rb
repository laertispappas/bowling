class Frame < ApplicationRecord
  belongs_to :game
  has_many :rolls
end
