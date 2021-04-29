# frozen_string_literal: true

class Github::ReadFile < Github::Base
  def initialize(prefix, master_only: false)
    @prefix      = prefix
    @master_only = master_only
  end

  def perform
    git.checkout('master')
    git.pull

    file_names.each do |file_name|
      file_content = read(file_name)

      return file_content if file_content.present?
    end
    nil
  end

  private

  attr_reader :prefix, :master_only

  def file_names
    master_only ? ["#{prefix}.master.json"] : ["#{prefix}.master.json", "#{prefix}.json"]
  end

  def read(file_name)
    File.read(
      Rails.root.join(github_path, file_name)
    )
  rescue StandardError => e
    Rails.logger.debug(e.message)
    nil
  end
end
