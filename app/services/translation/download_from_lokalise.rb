# frozen_string_literal: true

class Translation::DownloadFromLokalise < Translation::Base
  def perform
    languages = {}

    # attributes.limit(2).each do |key, _v|
    #   ap client.keys(project_id, { key_id: key })
    #   puts '-'*35
    # end
    # client.keys(project_id, { key_id: ['BMI_infoSections_references_headerTitle', 'BMI_infoSections_references_infoItems_reference2_title']})
    params = {
      include_translations: 1,
      filter_keys:          attributes.keys.join(',')
    }
    keys = client.keys(project_id, params)

    keys.collection.collect do |key|
      translations = translate(key)
      next if translations.blank?

      translations.each do |t|
        languages[t[:language].to_s] ||= {}
        languages[t[:language].to_s][key.key_name['web']] = t[:text]
      end
    end

    # {
    #   'ru' => {
    #     'key_name' => 'value',
    #     ...
    #   },
    #   ...
    #   'it' => {
    #     'key_name' => 'value',
    #     ...
    #   }
    # }

    languages
  end

  private

  def translate(key)
    key
      .translations
      .collect do |t|
        next if language == t['language_iso'] || t['translation'].blank?

        { language: t['language_iso'], text: t['translation'] }
      end.reject(&:blank?)
  end

  def prepare(key)
    {
      key_name:  key,
      platforms: %w[ios web android other]
    }
  end
end
