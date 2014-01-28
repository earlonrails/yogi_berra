# adapted from https://raw.github.com/rails/rails/master/activesupport/lib/active_support/core_ext/hash/keys.rb
class Hash
  def deep_transform_both!(&block)
    keys.each do |key|
      value = delete(key)
      normalized_key = key.to_s.gsub(/\./, "-")
      self[normalized_key] = value.is_a?(Hash) ? value.deep_transform_both!(&block) : yield(value)
    end
    self
  end

  def deep_stringify_keys_and_values!
    exceptable_data_types = [Fixnum, Float, String, Array, Time]
    deep_transform_both! do |element|
      if exceptable_data_types.include?(element.class)
        element
      else
        element.to_s
      end
    end
  end
end
