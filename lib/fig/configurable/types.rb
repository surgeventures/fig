# frozen_string_literal: true

require "dry-types"

require_relative "./coercions"

module Fig
  # Custom types for configuration settings
  module Types
    include ::Dry::Types.module
    include ::Dry::Types.module::Form

    # A coercible symbol
    Symbol = Symbol.constructor(Coercions.method(:to_sym))
    # A coercible bool extended to admit enabled/disabled
    #
    # NOTE: it doesn't work without safe, but I'm unsure why as dry-types doesn't seem to explain itself.
    #       My hunch is it has to do with the fact that Bool is defined as an ADT of True | False, but might be wronf
    Bool = ::Dry::Types.module::Form::Bool.constructor(Coercions.method(:enablement_to_bool)).safe
    class << self
      prepend(Module.new do
        # An array, coercible from a separated string
        def Array(member, separator: ",")
          coercion = proc { |value| Coercions.to_ary(value, separator) }

          super(member).constructor(coercion)
        end

        # A coercible URI; this is coerced
        def URI(**hints)
          coercion = proc { |value| Coercions.to_uri(value, :hints => hints) }

          Constructor(::Addressable::URI, coercion)
        end
      end)
    end
  end
end
