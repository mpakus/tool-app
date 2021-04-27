# frozen_string_literal: true

class Translation::UploadToLokalise
  def initialize(tool)
    @tool = tool
  end

  def perform
    params = []

    attributes.each { |k, v| params << prepare(k, v) }

    client.create_keys(project_id, params)
  end

  private

  attr_reader :tool

  def prepare(key, value)
    {
      key_name:     key,
      platforms:    %w[ios web android other],
      translations: [
        {
          language_iso: language,
          translation:  value
        }
      ]
    }
  end

  def attributes
    return @attributes if defined? @attributes

    @attributes = {}
    json_spec.flatten_path.each do |k, v|
      next unless v.is_a?(String)

      @attributes["#{name}_#{k}"] = v
    end

    @attributes
  end

  def project_id
    @project_id ||= Rails.application.credentials.lokalise[:id]
  end

  def client
    @client ||= Lokalise.client(Rails.application.credentials.lokalise[:key])
  end

  delegate :json_spec, :language, :name, to: :tool, prefix: false
end
