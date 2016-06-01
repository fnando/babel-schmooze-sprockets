module BabelSchmoozeSprockets
  class BabelProcessor
    DEFAULT_PRESETS = %w[
      es2015
    ].freeze

    DEFAULT_PLUGINS = %w[
      external-helpers
      transform-async-to-generator
      transform-es2015-modules-amd
      transform-es3-member-expression-literals
      transform-es3-property-literals
      transform-function-bind
    ].freeze

    DEFAULT_BABEL_OPTIONS = {
      presets: DEFAULT_PRESETS,
      plugins: DEFAULT_PLUGINS
    }.freeze

    def self.instance
      @instance ||= BabelProcessor.new(
        root_dir: File.expand_path("#{__dir__}/../.."),
        options: BabelProcessor::DEFAULT_BABEL_OPTIONS
      )
    end

    def self.call(input)
      instance.call(input)
    end

    def initialize(options)
      @options = options

      @cache_key = [
        self.class.name,
        Babel.new(@options.fetch(:root_dir)).version,
        VERSION,
        @options
      ].freeze
    end

    def call(input)
      data = input[:data]

      result = input[:cache].fetch(@cache_key + [input[:filename]] + [data]) do
        options = {
          moduleIds: true,
          sourceRoot: input[:load_path],
          moduleRoot: nil,
          filename: input[:filename],
          filenameRelative: Sprockets::PathUtils.split_subpath(input[:load_path], input[:filename]),
          sourceFileName: input[:source_path],
          sourceMaps: true,
          ast: false
        }.merge(@options.fetch(:options))

        if options[:moduleIds] && options[:moduleRoot]
          options[:moduleId] ||= File.join(options[:moduleRoot], input[:name])
        elsif options[:moduleIds]
          options[:moduleId] ||= input[:name]
        end

        Babel
          .new(@options.fetch(:root_dir))
          .transform(data, options)
      end

      map = Sprockets::SourceMapUtils.decode_json_source_map(JSON.generate(result["map"]))
      map = Sprockets::SourceMapUtils.combine_source_maps(input[:metadata][:map], map["mappings"])

      {data: result["code"], map: map}
    end
  end
end
