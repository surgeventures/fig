# frozen_string_literal: true

require "stringio"

require_relative "./env"

module Fig
  module Loader
    SECRET_TEXT = "*** SECRET ***"

    # A simple DSL to load configuration values
    module Dsl
      def self.included(klass)
        klass.instance_eval do
          extend(ClassMethods)
        end
      end

      module ClassMethods
        attr_reader :_loaders, :_configuration_class

        # Class macro to define how to load a given `setting` name from environment variables
        def load(setting, env: nil)
          @_loaders ||= {}

          if env
            @_loaders[setting] = {
              :loader => Env,
              :params => { :source => env }
            }
          end
        end

        # A class macro to define configuration class to load the values into
        def configuration_class(klass)
          @_configuration_class = klass
        end
      end

      # Create a loader
      def initialize
        # Initializes the loaders from the loader description on the class
        @loaders = self.class._loaders.transform_values do |loader_spec|
          loader_spec[:loader].new(**loader_spec[:params])
        end
      end

      # Get loaders
      def loaders
        @loaders
      end

      # Load the configuration, returning a configuration object with the settings filled in
      def load!
        klass         = self.class._configuration_class
        loaders       = @loaders
        configuration = klass.new

        loaders.each do |setting, loader|
          value = loader.value

          next unless value

          configuration.send(:"#{setting}=", value)
        end

        @configuration = configuration
      end
    end
  end
end
