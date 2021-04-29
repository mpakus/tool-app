# frozen_string_literal: true

class TranslateAndUploadTool < Que::Job
  def run(tool_id)
    tool = Tool.find(tool_id)

    translations = Translation::DownloadFromLokalise.new(tool).perform
    # translate => create branch - save to file => create pr
    Github::CreatePullRequest.new(tool, translations).perform
  end
end
