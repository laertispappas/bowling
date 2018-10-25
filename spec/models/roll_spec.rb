require 'rails_helper'

RSpec.describe Roll, type: :model do
  it { is_expected.to belong_to :frame }
  it { is_expected.to validate_presence_of :frame }
  it { is_expected.to validate_presence_of :pins }
  it { is_expected.to validate_inclusion_of(:pins).in_array((0..10).to_a) }
end
