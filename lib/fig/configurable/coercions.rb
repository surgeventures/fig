# frozen_string_literal: true

require "dry-types"
require "addressable/uri"

module Fig
  # Custom coercions for configuration types
  module Coercions
    extend Dry::Types::Coercions

    DUMMY_SCHEME = "DUMMY-SCHEME"

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

    # Coerces a string to an uri using `Addressable::URI#heuristic_parse` with optional hints
    #
    # NOTE: the default behaviour of `to_uri` differs crucially in one aspect
    #       from `heuristic_parse` – `heuristic_parse` assumes the scheme if `http`
    #       if it's neither hinted at nor specified in the URI string. `to_uri` just
    #       assumes an empty schem, producing a scheme-relative URI. If you need
    #       a concrete scheme, just hint it.
    def self.to_uri(input, hints: {})
      return input if input.nil? || empty_str?(input)

      # What's with this weird thing here? `heuristic_parse` always assumes that
      # a URI, lacking an explicit scheme, is a `http` URI. We specify a dummy scheme
      # as a hint if none is specified, so we can remove it and have a URI without
      # scheme specified, not assume any scheme
      parse_hints = hints.dup
      parse_hints[:scheme] ||= DUMMY_SCHEME

      result = Addressable::URI.heuristic_parse(input, parse_hints)

      if result.scheme == DUMMY_SCHEME
        result.scheme = nil
      end

      result
    end
  end
end
