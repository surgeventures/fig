# frozen_string_literal: true

require "dry-types"
require "set"

require_relative "./errors"
require_relative "./configurable/types"
require_relative "./configurable/setting"
require_relative "./configurable/setting_builder"

module Fig
  # A DSL to describe the configuration.
  module Configurable
    def self.included(klass)
      klass.const_set("Types", Types)
      klass.instance_variable_set(:@__settings_mutex__, Mutex.new)
      # We use prepend here, so that we make sure that setting descriptors
      # are always initialiazed first
      klass.singleton_class.prepend(PrependedClassMethods)
    end

    module PrependedClassMethods
      # Get settings defined for this configuration class, the settings are
      # instances of the setting descriptor class `Setting`
      def settings
        @settings
      end

      # A class macro to define a setting, for valid setting options
      # see `SettingBuilder` methods you can call on the result of this macro.
      #
      # Example usage:
      #   ```
      #   setting(:test)
      #     .type(Types::Int)
      #     .default(12)
      #     .required { |config| config.test_enabled? }
      #   ```
      def setting(name)
        setting_builder = SettingBuilder.new.name(name)

        (@setting_builders ||= []) << setting_builder

        setting_builder
      end

      # A thread-safe method to initialize setting descriptors for a given class
      private def build_settings!
        @__settings_mutex__.synchronize do
          @settings ||= begin
            result = @setting_builders.map do |builder|
              setting = builder.build!

              setting.define_methods!(self)

              setting
            end

            result.to_set
          end
        end
      end
    end

    # Get the settings available on this object as `Setting` setting descriptors
    def settings
      self.class.settings
    end

    # Initialize this setting object, this makes sure that setting descriptors are initialized first
    def initialize(*args)
      self.class.send(:build_settings!)

      super(*args)
    end

    # Validate if the configuration object settings are correct.
    #
    # NOTE: this is a very simple validation testing only if a settings' value
    #       is set; validating format of values (eg. string for an int) relies
    #       on them failing validation and not being set
    # TODO: make this validation better, eg. saying there's a type mismatch instead
    #       of relying on the set silently failing
    def validate!
      invalid_settings = []

      settings.each do |setting|
        invalid_settings << setting.name unless setting.valid?(self)
      end

      raise Fig::Errors::InvalidConfiguration.new(:invalid_settings => invalid_settings) unless invalid_settings.empty?
    end

    # Finalize the configuration, preventing unwanted modification
    def finalize!
      settings.each { |setting| setting.finalize!(self) }
      settings.freeze
      freeze
    end

    def to_h
      settings.map { |setting| [setting.name, send(setting.getter_name)] }.to_h
    end
  end
end
