# frozen_string_literal: true
require "test_helper"

class TestBabelProcessor < MiniTest::Test
  def test_compile_es6_features_to_es5
    input = {
      content_type: "application/ecmascript-6",
      data: "const square = (n) => n * n",
      metadata: {},
      load_path: File.expand_path("../fixtures", __FILE__),
      filename: File.expand_path("../fixtures/mod.es6", __FILE__),
      cache: Sprockets::Cache.new,
      source_path: "mod.source-XYZ.es6"
    }

    js = BabelSchmoozeSprockets::BabelProcessor.call(input)[:data]

    assert js
    assert_match(/var square/, js)
    assert_match(/function/, js)
  end

  def test_transform_arrow_function
    input = {
      content_type: "application/ecmascript-6",
      data: "var square = (n) => n * n",
      metadata: {},
      load_path: File.expand_path("../fixtures", __FILE__),
      filename: File.expand_path("../fixtures/mod.es6", __FILE__),
      cache: Sprockets::Cache.new,
      source_path: "mod.source-XYZ.es6"
    }

    js = babel_processor(plugins: []).call(input)[:data]

    assert js
    assert_equal <<-JS.chomp, js.strip
"use strict";

var square = function square(n) {
  return n * n;
};
    JS
  end

  def test_amd_modules
    input = {
      content_type: "application/ecmascript-6",
      data: %[import foo from "foo";],
      metadata: {},
      load_path: File.expand_path("../fixtures", __FILE__),
      filename: File.expand_path("../fixtures/mod.es6", __FILE__),
      cache: Sprockets::Cache.new,
      source_path: "mod.source-XYZ.es6"
    }

    js = babel_processor.call(input)[:data]

    assert js
    assert_equal <<-JS.chomp, js.strip
define("mod", ["foo"], function (_foo) {
  "use strict";

  var _foo2 = babelHelpers.interopRequireDefault(_foo);
});
  JS
  end

  def test_caching_takes_filename_into_account
    mod1 = {
      content_type: "application/ecmascript-6",
      data: "var square = (n) => n * n;",
      metadata: {},
      load_path: File.expand_path("../fixtures", __FILE__),
      filename: File.expand_path("../fixtures/mod1.es6", __FILE__),
      cache: Sprockets::Cache.new,
      source_path: "mod1.source-XYZ.es6"
    }

    mod2 = mod1.dup
    mod2[:filename] = File.expand_path("../fixtures/mod2.es6", __FILE__)

    js1 = babel_processor.call(mod1)[:data]
    assert js1
    assert_equal <<-JS.chomp, js1.to_s.strip
define("mod1", [], function () {
  "use strict";

  var square = function square(n) {
    return n * n;
  };
});
    JS

    js2 = babel_processor.call(mod2)[:data]
    assert js2
    assert_equal <<-JS.chomp, js2.to_s.strip
define("mod2", [], function () {
  "use strict";

  var square = function square(n) {
    return n * n;
  };
});
    JS
  end

  def babel_processor(options = {})
    BabelSchmoozeSprockets::BabelProcessor.new(
      root_dir: File.expand_path("#{__dir__}/../.."),
      options: {
        presets: BabelSchmoozeSprockets::BabelProcessor::DEFAULT_PRESETS,
        plugins: BabelSchmoozeSprockets::BabelProcessor::DEFAULT_PLUGINS,
      }.merge(options)
    )
  end
end
