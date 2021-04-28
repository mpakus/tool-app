# frozen_string_literal: true

class Translation::UploadToLokalise < Translation::Base
  def perform
    params = []

    attributes.each { |k, v| params << prepare(k, v) }

    client.create_keys(project_id, params)
  end

  private

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
end
