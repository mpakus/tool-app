# frozen_string_literal: true

class Tool < ApplicationRecord
  validates :name, :language, :json_spec, presence: true
  validates :language, length: { is: 2 }
end
