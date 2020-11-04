# frozen_string_literal: true

module Fig
  # A builder class for a setting descriptor
  class SettingBuilder
    # Setting with a name, this is required
    def name(name, defaults: {})
      @name = name

      @required = defaults[:required] if defaults.has_key?(:required)

      self
    end

    # Setting with a type, the value will be coerced to this type upon setting.
    # If the coercion fails, no value will be set silently at this time
    #
    # NOTE: a setting with type of `Types::Bool` will get a `name?` predicate for free
    # TODO: this probably should yell at you instead
    def type(type)
      @type = type

      self
    end

    # Setting with a default, either passed as a parameter (static) or as
    # a block (computed on first get of the setting; the block is passed
    # the current configuration, so you can decide the default based on some
    # other setting)
    def default(default = nil, &block)
      if block_given?
        @compute_default = true
        @default = block
      else
        @default = default
      end

      self
    end

    # Setting validated for presence, the decision to validate can be passed
    # either as a parameter, or as a block (computed when validated; the block
    # is passed the current configuration, so you can decide whether to validate
    # or not based on some other setting)
    def required(required = true, &block)
      if block_given?
        @compute_required = true
        @required = block
      else
        @required = required
      end

      self
    end

    # A convenient alias for a negated version of `required` if you're working with
    # a required-by-default config. To wit, it will make a value non-required when called
    # or when the block returns true.
    def optional(optional = true, &block)
      if block_given?
        required(!optional) { !block.call() }
      else
        required(!optional)
      end
    end

    # Builds a setting descriptor
    def build!
      Setting.new(
        :name             => @name,
        :type             => @type,
        :default          => @default,
        :compute_default  => @compute_default,
        :required         => @required,
        :compute_required => @compute_required
      )
    end
  end
end
