require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/registros/show.html.erb" do
  include RegistrosHelper
  before(:each) do
    assigns[:registro] = @registro = stub_model(Registro,
      :usuario_id => 1
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/1/)
  end
end
