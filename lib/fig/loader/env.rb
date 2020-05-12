# frozen_string_literal: true

module Fig
  module Loader
    # A class to load a configuration setting value from an environment variable
    class Env
      attr_reader :source

      # Create a loader loading the value from an environment variable `source`
      def initialize(source:)
        @source = source
        @loaded = false
      end

      # Was the setting loaded?
      def loaded?
        @loaded
      end

      # The setting value
      def value
        @value ||= begin
          if ENV.key?(source)
            @loaded = true
            ENV[source]
          end
        end
      end
    end
  end
end
