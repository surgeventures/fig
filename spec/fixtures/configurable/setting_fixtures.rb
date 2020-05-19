module SettingFixtures
  require "fig/configurable/setting"

  class Simple < Fig::Setting
    def initialize
      super(:name => :setting)
    end
  end

  class WithBoolean < Fig::Setting
    def initialize
      super(
        :name => :boolean,
        :type => Fig::Types::Bool
      )
    end
  end

  class WithDefault < Fig::Setting
    def initialize
      super(
        :name    => :with_default,
        :default => 42
      )
    end
  end
end
