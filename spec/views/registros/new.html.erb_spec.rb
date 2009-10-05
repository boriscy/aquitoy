require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/registros/new.html.erb" do
  include RegistrosHelper

  before(:each) do
    assigns[:registro] = stub_model(Registro,
      :new_record? => true,
      :usuario_id => 1
    )
  end

  it "renders new registro form" do
    render

    response.should have_tag("form[action=?][method=post]", registros_path) do
      with_tag("input#registro_usuario_id[name=?]", "registro[usuario_id]")
    end
  end
end
