# mock rails
class Rails
  def self.root
    "#{SPEC_FOLDER}/fixtures"
  end
end

ENV["RAILS_ENV"] = "test"