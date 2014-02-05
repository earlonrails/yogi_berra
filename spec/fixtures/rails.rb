# mock rails
class Rails
  def self.root
    "#{SPEC_FOLDER}/fixtures"
  end

  def self.env
    "test"
  end
end
YogiBerra.yogi_yml = "#{SPEC_FOLDER}/fixtures/config/yogi.yml"

ENV['RAILS_ENV'] = "test"
