ENV["RACK_ENV"] = "test"

begin
  require "pry"
rescue LoadError
end

require "bundler/setup"
require "minitest/autorun"
require "rack/test"

require "./app"

