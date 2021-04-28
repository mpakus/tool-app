# frozen_string_literal: true

class TranslateAndUploadTool < Que::Job
  def run(tool_id)
    tool = Tool.find(tool_id)

    translations = Translation::DownloadFromLokalise.new(tool).perform
    Github::CreatePullRequests.new(tool, translations).perform
  end
end
