require "fig/configurable"

RSpec.describe Fig::Configurable do
  describe "including the module" do
    subject { ConfigurationFixtures::Simple }

    it "provides the `setting` macro" do
      expect(subject).to respond_to(:setting)
    end

    it "provides the `settings` method on the class" do
      expect(subject).to respond_to(:settings)
    end

    it "provides the `Types` module" do
      expect(subject).to be_const_defined(:Types)
    end
  end

  describe "class methods" do
    describe "#setting macro" do
      subject { ConfigurationFixtures::Simple.new }

      describe "generates methods" do
        it "a getter" do
          expect(subject).to respond_to(:test)
        end

        it "a setter" do
          expect(subject).to respond_to(:test=)
        end
      end

      describe "with a type specified" do
        subject { ConfigurationFixtures::Coercion.new }

        context "generates methods" do
          it "a getter" do
            expect(subject).to respond_to(:numeric)
          end

          context "a setter" do
            it "accepting a value of the type" do
              subject.numeric = 42

              expect(subject.numeric).to eq(42)
            end

            it "coercing a value of the type" do
              subject.numeric = "9001"

              expect(subject.numeric).to eq(9001)
            end

            it "that does not assign a value if it does not coerce to the type" do
              subject.numeric = "not a number"

              expect(subject.numeric).to eq(nil)

              subject.numeric = 0xdeadbeef

              expect(subject.numeric).to eq(0xdeadbeef)

              subject.numeric = "not a number again"

              expect(subject.numeric).to eq(0xdeadbeef)
            end
          end
        end
      end

      describe "with `Types::Bool` type specified" do
        subject { ConfigurationFixtures::Boolean.new }

        context "generates methods" do
          it "a predicate" do
            expect(subject).to respond_to(:boolean?)
          end
        end
      end

      describe "with requiredness" do
        context "specified as a value" do
          subject { ConfigurationFixtures::Required.new }

          context "validating configuration" do
            it "fails if the value of the required setting is missing" do
              expect { subject.validate! }.to raise_error(Fig::Errors::InvalidConfiguration)
            end

            it "passes if the value of the required setting is present" do
              subject.test = "test"

              expect { subject.validate! }.not_to raise_error
            end
          end

          describe "with a type specified as well" do
            subject { ConfigurationFixtures::RequiredWithType.new }

            context "validating configuration" do
              it "fails if the value of the required setting was assigned a value not matching the type" do
                subject.numerics = "totally a list of numbers, trust me"

                expect { subject.validate! }.to raise_error(Fig::Errors::InvalidConfiguration)
              end
            end
          end
        end

        context "specified as a block" do
          subject { ConfigurationFixtures::ComputedRequired.new }

          context "validating configuration" do
            it "fails if the condition block evaluates to true and the value of the setting is missing" do
              subject.boolean = true

              expect { subject.validate! }.to raise_error(Fig::Errors::InvalidConfiguration)
            end

            it "passes if the condition block evaluates to false" do
              subject.boolean = false

              expect { subject.validate! }.not_to raise_error
            end
          end
        end
      end

      describe "with default" do
        context "specified as a value" do
          subject { ConfigurationFixtures::Default.new }

          it "the default is set if no value is present" do
            expect(subject.with_default).to eq(13.37)
          end

          it "the default is not set if a value is already present" do
            subject.with_default = "derp"

            expect(subject.with_default).to eq("derp")
          end
        end

        context  "specified as a block" do
          subject { ConfigurationFixtures::ComputedDefault.new }

          it "the default can be computed from the config" do
            subject.with_default = 2

            expect(subject.with_computed_default).to eq(4)
          end
        end
      end
    end

    describe "#settings" do
      subject { ConfigurationFixtures::Simple.new }

      it "returns a set of `Setting` objects for all the settings" do
        expect(subject.settings).to be_a(Set)
        expect(subject.settings).to have(1).element
        expect(subject.settings.map(&:name)).to contain_exactly(:test)
      end
    end
  end

  describe "instance methods" do
    subject { ConfigurationFixtures::Simple.new }

    context "#settings" do
      it "is defined" do
        expect(subject).to respond_to(:settings)
      end

      it "returns the settings defined on the configuration class" do
        expect(subject.settings).to eq(ConfigurationFixtures::Simple.settings)
      end
    end

    context "#validate!" do
      subject { ConfigurationFixtures::Simple.new }

      it "is defined" do
        expect(subject).to respond_to(:validate!)
      end

      it "validates the configuration as a side effect" do
        expect(subject.validate!).to be_nil
      end

      context "when configuration is invalid" do
        subject { ConfigurationFixtures::RequiredWithType.new }

        it "raises a `Fig::Errors::InvalidConfiguration` exception" do
          subject.numerics = "totally a list of numbers, trust me"

          expect { subject.validate! }.to raise_error(Fig::Errors::InvalidConfiguration)
        end

        it "the raised exception contains infomration on which settings are invalid" do
          subject.numerics = "insert some clever popculture reference here"

          expect { subject.validate! }.to raise_error do |error|
            expect(error.invalid_settings).to eq([:numerics])
            expect(error.message).to eq(<<~ERROR)
              Invalid settings in config:
                numerics
            ERROR
          end
        end
      end
    end
  end
end
