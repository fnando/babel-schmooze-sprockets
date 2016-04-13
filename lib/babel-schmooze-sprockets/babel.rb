module BabelSchmoozeSprockets
  class Babel < Schmooze::Base
    dependencies babel: "babel-core"

    method :transform, "babel.transform"
    method :version, "function() { return [process.version, babel.version]; }"
  end
end
