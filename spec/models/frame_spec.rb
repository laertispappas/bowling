require 'rails_helper'

RSpec.describe Frame, type: :model do
  it { is_expected.to belong_to :game }
  it { is_expected.to have_many :rolls }
end
