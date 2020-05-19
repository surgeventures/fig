require "fig/loader/dsl"

RSpec.describe Fig::Loader::Dsl do
  context "a value" do
    let(:test_setting_value) { "ja wisła ja wisła" }
    before(:each)            { stub_const("ENV", ENV.to_h.merge("TEST" => test_setting_value)) }

    subject { LoaderFixtures::Loader.new }

    it "is loaded from the associated envvar" do
      config = subject.load!

      expect(config.test).to eq(test_setting_value)
    end
  end
end
