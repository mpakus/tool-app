# frozen_string_literal: true

class Github::CreatePullRequest < Github::Base
  def initialize(tool, translations)
    @tool         = tool
    @translations = translations
  end

  def perform
    # {
    #   "ru" => {
    #     "BMI_infoSections_formula_infoItems_formula1_title"      => "ИМТ = вес / рост²",
    #     "BMI_infoSections_references_headerTitle"                => "Рекомендации",
    #   },
    #   "it" => {
    #     "BMI_infoSections_formula_infoItems_formula1_title"      => "BMI = peso / altezza²",
    #     "BMI_infoSections_references_headerTitle"                => "Riferimenti",
    #   }
    # }
    translations.each do |lang, keys|
      file = replace_values(keys, lang)
      save_file_and_create_pr(file, lang)
    end
    git.checkout('master')
  end

  private

  attr_reader :tool, :translations

  # --- Replace

  def replace_values(keys, lang)
    lang_file = JSON.parse(
      Github::ReadFile.new("#{tool.name}.#{tool.language}", master_only: true).perform
    )

    keys.each do |key, value|
      path = key.split(/_+/)
      path.shift # shift prefix
      lang_file.deep_set(path, value)
    end
    lang_file['language'] = lang.upcase
    lang_file
  end

  # --- Commit

  def save_file_and_create_pr(file, lang)
    git.checkout('master')

    file_name   = "#{tool.name}.#{lang}.json"
    branch_name = "#{tool.name}_#{lang.upcase}_#{Time.now.strftime('%Y%m%d%H%M')}"
    commit_msg  = "Translation for #{tool.name} to #{lang.upcase}"

    # create and checkout new branch
    git.branch(branch_name).checkout
    # write translation file add to git
    File.write(Rails.root.join(github_path, file_name), file)
    git.add(file_name)
    # commit and push to remote branch
    git.commit(commit_msg)
    git.push(git.remotes.first, branch_name)
    # create PR
    client.create_pull_request(
      Rails.configuration.app.dig(:github, :specs_repo),
      'master',
      branch_name,
      "Feature: #{commit_msg}",
      commit_msg
    )
  rescue StandardError => e
    Rails.logger.debug(e.message)
  end

  def client
    @client ||= Octokit::Client
                .new(access_token: Rails.application.credentials.github[:access_token])
  end
end
