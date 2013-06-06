# mock rails
ENV["RAILS_ENV"] = "test"

class Rails
  def self.root
    "#{SPEC_FOLDER}/fixtures"
  end
end