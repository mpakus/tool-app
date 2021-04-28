# frozen_string_literal: true

class Translation::Attributes
  def initialize(tool)
    @tool = tool
  end

  def perform
    return @attributes if defined? @attributes

    @attributes = {}
    json_spec.flatten_path.each do |k, v|
      next unless v.is_a?(String)

      @attributes["#{name}_#{k}"] = v
    end

    @attributes
  end

  private

  attr_reader :tool

  delegate :json_spec, :name, to: :tool, prefix: false
end
