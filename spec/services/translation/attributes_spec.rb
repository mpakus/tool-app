# frozen_string_literal: true

RSpec.describe Translation::Attributes do
  let(:tool) { Tool.create(name: 'BMI', language: 'en', json_spec: json_example) }
  let(:json_example) do
    JSON.parse('
      {
        "language": "EN",
        "result": {
          "resultRanges": {
            "bmi": {
              "title": "BMI",
              "shouldShowPoints": true,
              "pointsFrom": -1.0,
              "activityLevel": "gray"
            }
          }
        }
      }
    ')
  end

  describe '#perform' do
    let(:attributes) { described_class.new(tool).perform }

    it { expect(attributes['BMI_language']).to eq 'EN' }
    it { expect(attributes['BMI_result_resultRanges_bmi_title']).to eq 'BMI' }
    it { expect(attributes['BMI_result_resultRanges_bmi_activityLevel']).to eq 'gray' }

    # also skip non-string values
    it { expect(attributes['BMI_result_resultRanges_bmi_shouldShowPoints']).to be_nil }
    it { expect(attributes['BMI_result_resultRanges_bmi_pointsFrom']).to be_nil }
  end
end
