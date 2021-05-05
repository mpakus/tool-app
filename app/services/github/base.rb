# frozen_string_literal: true

class Github::Base
  private

  def git
    @git ||= Git.open(Rails.root.join(github_path))
  end

  def github_path
    Rails.configuration.app.dig(:github, :dir)
  end
end
