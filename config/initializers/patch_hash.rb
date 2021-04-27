# frozen_string_literal: true

class Hash
  def flatten_path
    each_with_object({}) do |(k, v), h|
      if v.is_a?(Hash)
        v.flatten_path.map { |h_k, h_v| h["#{k}_#{h_k}"] = h_v }
      else
        h[k] = v
      end
    end
  end
end
