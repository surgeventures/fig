module Fig
  class Error < StandardError; end

  module Errors
    class InvalidConfiguration < Error
      attr_reader :invalid_settings

      def initialize(invalid_settings: [])
        @invalid_settings = invalid_settings

        super("Invalid settings in config:\n  #{invalid_settings.join("\n  ")}\n")
      end
    end

    class FinalizedConfiguration < Error
      def initialize
        super("Cannot modify a finalized configuration!")
      end
    end
  end
end
