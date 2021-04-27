# frozen_string_literal: true

class FetchJsonFile < Que::Job
  def run(tool_id)
    tool = Tool.find(tool_id)

    # fetch JSON and update model
    file = Github::ReadFile.new("#{tool.name}.#{tool.language}").perform
    return if file.blank?

    tool.update(json_spec: JSON.parse(file))

    # prepare keys from JSON and upload to Lokalise
    Translation::UploadToLokalise.new(tool).perform
  end
end
