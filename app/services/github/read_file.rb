# frozen_string_literal: true

class Github::ReadFile
  require 'open-uri'

  def initialize(prefix)
    @prefix = prefix
  end

  def perform
    ["#{prefix}.master.json", "#{prefix}.json"].each do |file_name|
      url = fetch(file_name)
      next if url.blank?

      return read(url)
    end
    nil
  end

  private

  attr_reader :prefix

  def fetch(file_name)
    Octokit.contents(github_specs_repo, path: file_name)[:download_url]
  rescue StandardError => e
    Rails.logger.debug(e.message)
    nil
  end

  def read(url)
    # https://raw.githubusercontent.com/mpakus/tool-specs/master/BMI.en.master.json
    URI.parse(url).open(&:read)
  end

  def github_specs_repo
    Rails.configuration.app.dig(:github, :specs_repo)
  end
end
