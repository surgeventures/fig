# frozen_string_literal: true

require "set"

require_relative "./types"

module Fig
  # A class describing a configuration setting
  #
  # NOTE: `klass` parameter name usually referes to the class object of a configuration
  #       while `instance` refers to a configuration object instantiated from that class
  class Setting
    attr_accessor :name, :type

    # Create a setting descriptor
    def initialize(
      name:,
      type:             nil,
      default:          nil,
      compute_default:  false,
      required:         false,
      compute_required: false
    )
      @name             = name
      @type             = type
      @default          = default
      @compute_default  = compute_default
      @required         = required
      @compute_required = compute_required
    end

    # Defines methods handling a given setting, given a `klass` to define them on
    def define_methods!(klass)
      define_getter!(klass)
      define_predicate!(klass)
      define_setter!(klass)
    end

    # Instance variable name for the setting
    def ivar_name
      @ivar_name ||= :"@#{name}"
    end

    # Getter method name for the setting
    def getter_name
      @getter_name ||= @name
    end

    # Setter method name for the setting
    def setter_name
      @setter_name ||= :"#{name}="
    end

    # Predicate method name for the setting
    def predicate_name
      @predicate_name ||= :"#{name}?"
    end

    # Compute the default value for the setting, given a configuration object `instance`
    def default(instance)
      if @compute_default
        @default.call(instance)
      else
        @default
      end
    end

    # Compute the requiredness for the setting, given a configuration object `instance`
    def required?(instance)
      result = if @compute_required
        @required.call(instance)
      else
        @required
      end

      result || false
    end

    # Compute the validity for the setting, given a configuration object `instance`
    def valid?(instance)
      if required?(instance)
        !get(instance).nil?
      else
        true
      end
    end

    # Get the value of the setting, as set on the configuration object `instance`
    private def get(instance)
      instance.send(:instance_variable_get, ivar_name)
    end

    # Set the value of the setting to a `new_value` on the configuration object `instance`
    def set!(instance, new_value)
      instance.send(:instance_variable_set, ivar_name, new_value)
    end

    # Check if the setting has a set value on the configuration object `instance`
    def defined?(instance)
      instance.send(:instance_variable_defined?, ivar_name)
    end

    # Get the value of the setting, as set on the configuration object `instance`;
    # If no value is present, the default value will be set
    def get_or_set_default!(instance)
      set!(instance, default(instance)) unless self.defined?(instance)

      get(instance)
    end

    # Finalize the setting
    def finalize!(instance)
      setting = self

      # Make sure the default is computed before finalizing
      get_or_set_default!(instance).freeze

      instance.define_singleton_method(setter_name) do |_|
        raise Errors::FinalizedConfiguration.new(:setting_name => setting.name)
      end

      self.freeze
    end

    # Tries to coerce a value to the setting's type, returning a `Dry::Types::Result`
    def try_coerce(value)
      if type
        type.try(value)
      else
        Dry::Types::Result::Success.new(value)
      end
    end

    # Defines a getter for the setting, given a `klass` to define it on.
    #
    # NOTE: getter will set the default value on the instance, if no value is set
    private def define_getter!(klass)
      setting = self

      klass.send(:define_method, getter_name) do
        setting.get_or_set_default!(self)
      end
    end

    # Defines a predicate for the setting (if applicable), given a `klass` to define it on
    private def define_predicate!(klass)
      setting = self

      if type == Types::Bool
        klass.send(:define_method, predicate_name) do
          self.send(setting.getter_name) || false
        end
      end
    end

    # Defines a setter for the setting, given a `klass` to define it on
    #
    # NOTE: setter will try to coerce the value, if a type is specified; if the
    #       coercion fails, no value will be set
    private def define_setter!(klass)
      setting = self

      if type
        klass.send(:define_method, setter_name) do |value|
          result = setting.try_coerce(value)

          setting.set!(self, result.input) if result.success?
        end
      else
        klass.send(:define_method, setter_name) do |value|
          setting.set!(self, value)
        end
      end
    end
  end
end
