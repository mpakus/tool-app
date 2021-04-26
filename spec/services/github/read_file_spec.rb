# frozen_string_literal: true

RSpec.describe Github::ReadFile do
  context 'when file not exist' do
    subject do
      VCR.use_cassette('WRONG.en') { described_class.new('WRONG.en').perform }
    end

    it { is_expected.to be_nil }
  end

  context 'when file exist' do
    subject do
      VCR.use_cassette('BMI.en.master') { described_class.new('BMI.en').perform }
    end

    it { is_expected.not_to be_nil }
  end
end
