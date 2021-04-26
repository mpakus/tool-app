# frozen_string_literal: true

RSpec.describe Tool, type: :model do
  context 'with validations' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :language }
    it { is_expected.to validate_length_of(:language).is_equal_to(2) }
  end
end
