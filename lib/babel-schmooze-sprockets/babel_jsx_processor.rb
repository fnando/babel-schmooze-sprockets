module BabelSchmoozeSprockets
  class BabelJSXProcessor < BabelProcessor
    def self.default_plugins
      @default_plugins ||= super.concat(%w[transform-react-jsx])
    end
  end
end
