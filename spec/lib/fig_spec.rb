RSpec.describe Fig do
  it "has a version number" do
    expect(Fig).to be_const_defined(:VERSION)
    expect(Fig::VERSION).not_to be nil
  end

  it "provides `Fig::Configurable`" do
    expect(Fig).to be_const_defined(:Configurable)
  end

  it "provides `Fig::Loader::Dsl`" do
    expect(Fig).to be_const_defined(:Loader)
    expect(Fig::Loader).to be_const_defined(:Dsl)
  end
end
