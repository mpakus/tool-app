# frozen_string_literal: true

module ApplicationHelper
  def flash_class(type)
    {
      'success' => 'alert-success',
      'error' => 'alert-danger',
      'notice' => 'alert-info',
      'alert' => 'alert-danger',
      'warn' => 'alert-warning'
    }[type]
  end
end
