# frozen_string_literal: true

require "dry-types"
require "addressable/uri"

module Fig
  # Custom coercions for configuration types
  module Coercions
    extend Dry::Types::Coercions

    # Coerces a string input into an array of strings, split by a separator
    def self.to_ary(input, separator = ",")
      return [] if input.nil?
      return input unless input.is_a?(String)
      return [] if empty_str?(input)

      input.split(separator)
    end

    # Coerces a symbol-coercible input into a symbol
    def self.to_sym(input)
      return input.to_sym if input.respond_to?(:to_sym)

      input
    end

    # Coerces a symbol-coercible input into a symbol
    def self.enablement_to_bool(input)
      return input unless input.is_a?(String)

      return true  if input.strip == "enabled"
      return false if input.strip == "disabled"

      input
    end

    # Coerces
    def self.to_uri(input)
      return input if input.nil? || empty_str?(input)

      Addressable::URI.parse(input)
    end
  end
end
