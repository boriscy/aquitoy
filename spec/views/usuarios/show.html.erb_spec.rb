require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/usuarios/show.html.erb" do
  include UsuariosHelper
  before(:each) do
    assigns[:usuario] = @usuario = stub_model(Usuario,
      :nombre => "value for nombre",
      :paterno => "value for paterno",
      :materno => "value for materno",
      :ci => "value for ci"
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/value\ for\ nombre/)
    response.should have_text(/value\ for\ paterno/)
    response.should have_text(/value\ for\ materno/)
    response.should have_text(/value\ for\ ci/)
  end
end
