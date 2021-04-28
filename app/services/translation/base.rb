# frozen_string_literal: true

class Translation::Base
  def initialize(tool)
    @tool = tool
  end

  private

  attr_reader :tool

  def attributes
    return @attributes if defined? @attributes

    @attributes = Translation::Attributes.new(tool).perform

    @attributes
  end

  def project_id
    @project_id ||= Rails.application.credentials.lokalise[:id]
  end

  def client
    @client ||= Lokalise.client(Rails.application.credentials.lokalise[:key])
  end

  delegate :name, :json_spec, :language, to: :tool, prefix: false
end
