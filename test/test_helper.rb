require 'minitest/autorun'
require 'material_raingular/websocket'
require 'minitest/reporters'
require 'flying_table'
ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new


class TestCase < MiniTest::Test
end
