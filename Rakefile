require "bundler/gem_tasks"
require "rspec/core/rake_task"

# Don't push the gem on rake release
ENV["gem_push"] = "no"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec
