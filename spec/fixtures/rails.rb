# mock rails
ENV["RAILS_ENV"] = "test"

class Rails
  def self.root
    "spec/fixtures"
  end
end