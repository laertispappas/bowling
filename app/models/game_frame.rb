class GameFrame < ApplicationRecord
  belongs_to :game
  belongs_to :user
  has_many :frames
end
