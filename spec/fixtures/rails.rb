# mock rails
class Rails
  def self.root
    "#{SPEC_FOLDER}/fixtures"
  end

  def self.env
    "test"
  end
end

ENV['RAILS_ENV'] = "test"