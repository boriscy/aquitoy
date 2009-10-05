require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/usuarios/edit.html.erb" do
  include UsuariosHelper

  before(:each) do
    assigns[:usuario] = @usuario = stub_model(Usuario,
      :new_record? => false,
      :nombre => "value for nombre",
      :paterno => "value for paterno",
      :materno => "value for materno",
      :ci => "value for ci"
    )
  end

  it "renders the edit usuario form" do
    render

    response.should have_tag("form[action=#{usuario_path(@usuario)}][method=post]") do
      with_tag('input#usuario_nombre[name=?]', "usuario[nombre]")
      with_tag('input#usuario_paterno[name=?]', "usuario[paterno]")
      with_tag('input#usuario_materno[name=?]', "usuario[materno]")
      with_tag('input#usuario_ci[name=?]', "usuario[ci]")
    end
  end
end
