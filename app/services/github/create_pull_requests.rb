# frozen_string_literal: true

class Github::CreatePullRequests < Translation::Base
  def initialize(tool, translations)
    @tool = tool
    @translations = translations
  end

  def perform
    translations.each do |_lang, keys|
      file = replace_values(keys)
      # lang
      # create_pr(
      #   upload(file)
      # )
    end
  end

  private

  attr_reader :tool, :translations

  def client
    @client ||= Octokit::Client
                .new(access_token: Rails.application.credentials.github[:access_token])
  end

  def replace_values(keys)
    lang_file = master_file.dup # clone
    keys.each do |key, value|
      path = key.split(/_+/)
      path.shift # shift prefix
      lang_file.deep_set(path, value)
    end
    lang_file
  end

  def master_file
    @master_file ||= JSON.parse(
      Github::ReadFile.new("#{tool.name}.#{tool.language}", true).perform
    )
  end
end
