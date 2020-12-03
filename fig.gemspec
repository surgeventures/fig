lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "fig/version"

Gem::Specification.new do |spec|
  spec.name          = "fig"
  spec.version       = Fig::VERSION
  spec.authors       = ["Tomek Mańko"]
  spec.email         = ["tomasz.manko@fresha.com"]

  spec.summary       = %q{A simple app configuration library}
  spec.description   = %q{See README.md}
  spec.homepage      = "https://github.com/surgeventures/fig"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "/dev/null"

    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/surgeventures/fig"
    spec.metadata["changelog_uri"] = "https://github.com/surgeventures/fig/blob/master/CHANGELOG.md"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  spec.files         = Dir["lib/**/*.rb"] + ["LICENSE.txt", "README.md", "CHANGELOG.md"]
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "dry-types",  "~> 1.0"
  spec.add_runtime_dependency "dry-equalizer", "~> 0.3.0"
  spec.add_runtime_dependency "addressable", "~> 2.5"

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rspec-collection_matchers", "~> 1.2.0"
  spec.add_development_dependency "pry", "~> 0.13.1"
  spec.add_development_dependency "pry-byebug", "~> 3.9.0"
  spec.add_development_dependency "byebug", "~> 11.1.3"
  spec.add_development_dependency "rspec_junit_formatter", "~> 0.4.1"
end
