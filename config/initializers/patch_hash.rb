# frozen_string_literal: true

class Hash
  # Return all paths flatten
  #   @example
  #   { x: { y: { z: 1 } } }
  #   =>
  #   { 'x_y_z': 1 }
  def flatten_path
    each_with_object({}) do |(k, v), h|
      if v.is_a?(Hash)
        v.flatten_path.map { |h_k, h_v| h["#{k}_#{h_k}"] = h_v }
      else
        h[k] = v
      end
    end
  end

  # Deep set
  #   @example
  #   .deep_set([:level1, :level2, ..., :levelX], value)
  def deep_set(path, value)
    final_dir = path.pop

    position = self
    path.each do |dir|
      position[dir] = {} unless position[dir].is_a?(Hash)
      position = position[dir]
    end
    position[final_dir] = value
  end
end
