require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/usuarios/index.html.erb" do
  include UsuariosHelper

  before(:each) do
    assigns[:usuarios] = [
      stub_model(Usuario,
        :nombre => "value for nombre",
        :paterno => "value for paterno",
        :materno => "value for materno",
        :ci => "value for ci"
      ),
      stub_model(Usuario,
        :nombre => "value for nombre",
        :paterno => "value for paterno",
        :materno => "value for materno",
        :ci => "value for ci"
      )
    ]
  end

  it "renders a list of usuarios" do
    render
    response.should have_tag("tr>td", "value for nombre".to_s, 2)
    response.should have_tag("tr>td", "value for paterno".to_s, 2)
    response.should have_tag("tr>td", "value for materno".to_s, 2)
    response.should have_tag("tr>td", "value for ci".to_s, 2)
  end
end
