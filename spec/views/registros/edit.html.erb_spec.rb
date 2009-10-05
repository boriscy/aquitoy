require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/registros/edit.html.erb" do
  include RegistrosHelper

  before(:each) do
    assigns[:registro] = @registro = stub_model(Registro,
      :new_record? => false,
      :usuario_id => 1
    )
  end

  it "renders the edit registro form" do
    render

    response.should have_tag("form[action=#{registro_path(@registro)}][method=post]") do
      with_tag('input#registro_usuario_id[name=?]', "registro[usuario_id]")
    end
  end
end
