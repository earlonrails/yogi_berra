# adapted from https://raw.github.com/rails/rails/master/activesupport/lib/active_support/core_ext/hash/keys.rb
class Hash
  def deep_transform_both!(&block)
    keys.each do |key|
      value = delete(key)
      self[yield(key)] = value.is_a?(Hash) ? value.deep_transform_both!(&block) : yield(value)
    end
    self
  end

  def deep_stringify_keys_and_values!
    exceptable_data_types = [Fixnum, Float, String]
    deep_transform_both!{ |element| element.to_s unless exceptable_data_types.include?(element.class) }
  end
end
