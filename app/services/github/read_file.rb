# frozen_string_literal: true

class Github::ReadFile
  require 'open-uri'

  def initialize(prefix, master_only: false)
    @prefix = prefix
    @master_only = master_only
  end

  def perform
    file_names.each do |file_name|
      url = fetch(file_name)
      next if url.blank?

      return read(url)
    end
    nil
  end

  private

  attr_reader :prefix, :master_only

  def file_names
    master_only ? ["#{prefix}.master.json"] : ["#{prefix}.master.json", "#{prefix}.json"]
  end

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
