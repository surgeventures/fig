module SettingHelpers
  def spy_setting(setting)
    allow(setting).to receive(:define_methods!).and_call_original
    allow(setting).to receive(:define_getter!).and_call_original
    allow(setting).to receive(:define_predicate!).and_call_original
    allow(setting).to receive(:define_setter!).and_call_original

    allow(setting).to receive(:defined?).and_call_original
    allow(setting).to receive(:default).and_call_original
    allow(setting).to receive(:set!).and_call_original
    allow(setting).to receive(:get).and_call_original

    setting
  end
end
