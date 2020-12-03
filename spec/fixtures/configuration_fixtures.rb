module ConfigurationFixtures
  require "fig/configurable"

  class Simple
    include Fig::Configurable

    setting(:test)
  end

  class Boolean
    include Fig::Configurable

    setting(:boolean).type(Types::Bool)
  end

  class Coercion
    include Fig::Configurable

    setting(:numeric).type(Types::Int)
  end

  class Required
    include Fig::Configurable

    setting(:test).required
  end

  class RequiredWithType
    include Fig::Configurable

    setting(:numerics).type(Types::Array(Types::Int)).required
  end

  class ComputedRequired
    include Fig::Configurable

    setting(:boolean).type(Types::Bool)
    setting(:required_if_boolean).required { |config| config.boolean? }
  end

  class Default
    include Fig::Configurable

    setting(:with_default).default(13.37)
  end

  class ComputedDefault
    include Fig::Configurable

    setting(:with_default).default(13.37)
    setting(:with_computed_default).default { |config| config.with_default * 2 }
  end

  class RequiredByDefault
    include Fig::Configurable

    required_by_default!

    setting(:required)
    setting(:overriden_to_optional).optional
  end
end
