# frozen_string_literal: true

class FetchJsonFile < Que::Job
  def run(tool_id)
    tool = Tool.find(tool_id)
    file = Github::ReadFile.new("#{tool.name}.#{tool.language}").perform
    return if file.blank?

    tool.update(json_spec: file)
  end
end
