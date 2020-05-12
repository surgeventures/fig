require_relative "./configuration_fixtures"

module LoaderFixtures
  require "fig/configurable"
  require "fig/loader/dsl"

  class Loader
    include Fig::Loader::Dsl

    configuration_class ConfigurationFixtures::Simple

    load :test, :env => "TEST"
  end
end
