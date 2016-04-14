module BabelSchmoozeSprockets
  class Railtie < Rails::Railtie
    initializer "babel-schmooze-sprockets" do
      config.assets.paths << File.expand_path("#{__dir__}/../../node_modules")
    end
  end
end
