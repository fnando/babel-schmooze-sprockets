require "schmooze"
require "sprockets"

module BabelSchmoozeSprockets
  require "babel-schmooze-sprockets/version"
  require "babel-schmooze-sprockets/babel"
  require "babel-schmooze-sprockets/babel_processor"
  require "babel-schmooze-sprockets/babel_jsx_processor"

  Sprockets.register_transformer(
    "application/ecmascript-6",
    "application/javascript",
    BabelProcessor
  )

  Sprockets.register_mime_type "application/jsx", extensions: [".jsx", ".js.jsx"], charset: :unicode
  Sprockets.register_transformer "application/jsx", "application/javascript", BabelJSXProcessor
  Sprockets.register_preprocessor "application/jsx", Sprockets::DirectiveProcessor.new(comments: ["//", ["/*", "*/"]])

  begin
    require "rails"
    require "babel-schmooze-sprockets/engine"
  rescue LoadError
  end
end
