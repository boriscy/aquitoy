require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/registros/index.html.erb" do
  include RegistrosHelper

  before(:each) do
    assigns[:registros] = [
      stub_model(Registro,
        :usuario_id => 1
      ),
      stub_model(Registro,
        :usuario_id => 1
      )
    ]
  end

  it "renders a list of registros" do
    render
    response.should have_tag("tr>td", 1.to_s, 2)
  end
end
