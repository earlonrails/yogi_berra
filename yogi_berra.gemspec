# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "yogi_berra/version"

Gem::Specification.new do |s|
  s.name          = "yogi_berra"
  s.summary       = "Catches errors in your rails app and doesn't get in the way."
  s.description   = "If the world were perfect, it wouldn't be. So you need the best error catcher of all time!"
  s.homepage      = "http://github.com/earlonrails/yogi_berra"
  s.authors       = ["Kevin Earl Krauss"]
  s.email         = "earlkrauss@gmail.com"
  s.license       = 'MIT'

  s.files         = Dir["lib/**/*"] + ["Gemfile", "LICENSE", "Rakefile", "README.md"]
  s.test_files    = Dir["spec/**/*"]
  s.version       = YogiBerra::VERSION

  s.require_paths = ["lib"]
  s.add_development_dependency('rake', '10.0.4')
  s.add_development_dependency('rspec', '2.13.0')
  s.add_dependency('bson', '1.8.3')
  s.add_dependency('bson_ext', '1.8.3') unless defined? JRUBY_VERSION
  s.add_dependency('mongo', '1.8.3')
end

