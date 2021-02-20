require "fig/configurable/coercions"

RSpec.describe Fig::Coercions do
  describe "#to_uri coercion" do

    it "a URI with no scheme will not assume a scheme when parsed" do
      result = subject.to_uri("google.com")

      expect(result.scheme).to be_nil
    end

    it "a URI with no scheme will assume the hinted scheme when parsed" do
      result = subject.to_uri("google.com", :hints => { :scheme => "test" })

      expect(result.scheme).to eq("test")
    end

    it "a URI with numbers parses correctly" do
      result = subject.to_uri("421337.dkr.ecr.region.amazonaws.com")

      expect(result.to_s).to eq("//421337.dkr.ecr.region.amazonaws.com")
    end
  end
end
