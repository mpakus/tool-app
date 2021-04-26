# frozen_string_literal: true

class Tool < ApplicationRecord
  after_commit :fetch_json_file

  validates :name, :language, presence: true
  validates :language, length: { is: 2 }

  private

  # Fetch json spec file from github everytime when save model and json_spec blank
  #  call the force: .send(:check_json_spec)
  def fetch_json_file
    return if json_spec.present?

    FetchJsonFile.enqueue(id)
  end
end
