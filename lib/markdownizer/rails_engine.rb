# encoding: UTF-8

module Markdownizer
  class Engine < Rails::Engine
    initializer "qa.load_app_instance_data" do |app|
      app.class.configure do
        config.paths["app/assets"] += Markdownizer::Engine.paths["app/assets"].existent
      end
    end
  end if defined?(Rails)
end
