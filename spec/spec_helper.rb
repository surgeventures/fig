require "bundler/setup"

require "pry"
require "pry-byebug"
require "rspec/collection_matchers"

require "fig"

fixture_files = Dir[File.join(File.dirname(__FILE__), "fixtures/**_fixtures.rb")]

fixture_files.each do |fixture_file|
  require_relative fixture_file
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
