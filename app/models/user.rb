class User < ApplicationRecord
  has_one :game_frame
  validates_presence_of :name
end
