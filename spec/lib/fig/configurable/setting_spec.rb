require "fig/configurable/setting"

RSpec.describe Fig::Setting do
  subject { spy_setting(fixture.new) }

  let(:fixture)      { SettingFixtures::Simple }
  let(:config_klass) { Class.new.tap { |c| subject.define_methods!(c) } }
  let(:config)       { config_klass.new }

  context "defining methods" do
    let(:config_klass) { Class.new }

    before do
      allow(config_klass).to receive(:define_method)
    end

    it "delegates to correct methods" do
      subject.define_methods!(config_klass)

      expect(subject).to have_received(:define_getter!).with(config_klass)
      expect(subject).to have_received(:define_predicate!).with(config_klass)
      expect(subject).to have_received(:define_setter!).with(config_klass)
    end

    context "#define_getter!" do
      it "defines a getter on the class" do
        subject.send(:define_getter!, config_klass)

        expect(config_klass).to have_received(:define_method).once.with(:setting)
      end
    end

    context "#define_setter" do
      it "defines a setter on the class" do
        subject.send(:define_setter!, config_klass)

        expect(config_klass).to have_received(:define_method).once.with(:setting=)
      end
    end

    context "#define_predicate!" do
      context "a setting with `Types::Bool`" do
        let(:fixture) { SettingFixtures::WithBoolean }

        it "defines a predicate on the class" do
          subject.send(:define_predicate!, config_klass)

          expect(config_klass).to have_received(:define_method).once.with(:boolean?)
        end
      end

      context "a setting with any other type" do
        let(:fixture) { SettingFixtures::Simple }

        it "does not define a predicate on the class" do
          subject.send(:define_predicate!, config_klass)

          expect(config_klass).not_to have_received(:define_method)
        end
      end
    end
  end

  context "handling defaults" do
    let(:fixture)      { SettingFixtures::WithDefault }

    it "the default checks if the setting is defined `Setting#defined?`" do
      config.with_default

      expect(subject).to have_received(:defined?).once
    end

    it "the default is computed if it's not already set" do
      config.with_default

      expect(subject).to have_received(:defined?).once
      expect(subject).to have_received(:default).once
      expect(subject).to have_received(:set!).once
      expect(subject).to have_received(:get).once
    end

    it "the default is not computed if it's already set" do
      config.with_default
      config.with_default

      expect(subject).to have_received(:defined?).twice
      expect(subject).to have_received(:default).once
      expect(subject).to have_received(:set!).once
      expect(subject).to have_received(:get).twice
    end
  end
end
