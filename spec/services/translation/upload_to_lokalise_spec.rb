# frozen_string_literal: true

RSpec.describe Translation::UploadToLokalise do
  let(:project_id) { Rails.application.credentials.lokalise[:id] }
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
  let(:attributes) do
    attributes = []

    tool.json_spec.flatten_path.each do |k, v|
      next unless v.is_a?(String)

      key = "#{tool.name}_#{k}"
      attributes << {
        key_name:     key,
        platforms:    %w[ios web android other],
        translations: [
          {
            language_iso: tool.language,
            translation:  v
          }
        ]
      }
    end
    attributes
  end
  let(:lokalise_client) { instance_double(Lokalise::Client) }

  describe '#perform' do
    it 'is prepare and call Lokalise::Client with correct keys' do
      allow(Lokalise).to receive(:client).and_return(lokalise_client)
      allow(lokalise_client).to receive(:create_keys).with(project_id, attributes).and_return(nil)

      described_class.new(tool).perform
    end
  end
end
