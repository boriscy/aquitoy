require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Usuario do
  before(:each) do
    @valid_attributes = {
      :nombre => "value for nombre",
      :paterno => "value for paterno",
      :materno => "value for materno",
      :ci => "value for ci"
    }
    @usuario = Usuario.new(@valid_attributes)
  end

  it "should create a new instance given valid attributes" do
    Usuario.create!(@valid_attributes)
  end

  it "tener nombre_completo" do
  end
end
