# frozen_string_literal: true
require "test_helper"

class TestBabelJSXProcessor < MiniTest::Test
  def test_compile_jsx_code
    input = {
      content_type: "application/jsx",
      data: "const jsx = <div>Hello</div>;",
      metadata: {},
      load_path: File.expand_path("../fixtures", __FILE__),
      filename: File.expand_path("../fixtures/mod.jsx", __FILE__),
      cache: Sprockets::Cache.new,
      source_path: "mod.source-XYZ.jsx"
    }

    js = BabelSchmoozeSprockets::BabelJSXProcessor.call(input)[:data]
    assert js.include?("React.createElement")
  end
end
