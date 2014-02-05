# require 'rails/generators/base'

module YogiBerra
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Creates a YogiBerra initializer."

      source_root File.expand_path('../templates', __FILE__)
      class_option :resque, :type => :boolean, :desc => 'Add support for handling errors in Resque jobs.'
      class_option :sidekiq, :type => :boolean, :desc => 'Add support for handling errors in Sidekiq jobs.'

      def copy_initializer
        template 'yogi_berra.rb', 'config/initializers/yogi_berra.rb'
      end
    end
  end
end