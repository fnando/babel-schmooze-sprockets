require "schmooze"
require "sprockets"

module BabelSchmoozeSprockets
  require "babel-schmooze-sprockets/version"
  require "babel-schmooze-sprockets/babel"
  require "babel-schmooze-sprockets/babel_processor"

  Sprockets.register_transformer(
    "application/ecmascript-6",
    "application/javascript",
    BabelProcessor
  )
end
