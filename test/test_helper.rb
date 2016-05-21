require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require "bundler/setup"
require "babel-schmooze-sprockets"
require "minitest/utils"
require "minitest/autorun"
