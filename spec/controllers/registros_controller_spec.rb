require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RegistrosController do

  before(:each) do
    @us = mock("hola", :record => mock_usuario)
    UsuarioSession.stub(:find).and_return(@us)
  end

  def mock_registro(stubs={})
    @mock_registro ||= mock_model(Registro, stubs)
  end

  def mock_usuario(stubs={})
    @mock_usuario ||= mock_model(Usuario, stubs)
  end

  def mock_I18n(stubs={})
    @mock_i18n ||= mock(I18n, stubs)
  end

  describe "GET index" do

    it "assigns all registros as @registros" do
      Registro.stub!(:all).and_return([mock_registro])
      get :index
      assigns[:registros].should == [mock_registro]
    end

  end

  describe "GET show" do
    it "assigns the requested registro as @registro" do
      Registro.stub!(:find).with("37").and_return(mock_registro)
      get :show, :id => "37"
      assigns[:registro].should equal(mock_registro)
    end
  end

  describe "GET new" do
    it "assigns a new registro as @registro" do
      Registro.stub!(:new).and_return(mock_registro)
      get :new
      assigns[:registro].should equal(mock_registro)
    end
  end

  describe "GET edit" do
    it "assigns the requested registro as @registro" do
      Registro.stub!(:find).with("37").and_return(mock_registro)
      get :edit, :id => "37"
      assigns[:registro].should equal(mock_registro)
    end
  end

  #############################################
  # Stubs para poder crear
  def stubs_create()
    Usuario.stub!(:find_by_ci).with(anything()).and_return(mock_model(Usuario, :nombre_completo => '', :ci => ''))
    Registro.stub!(:new).with(kind_of(Hash)).and_return(mock_registro(:save => true, :tipo_print => '', :created_at => ''))
    Registro.stub!(:new).and_return(mock_registro())
    I18n.stub!(:l).with(anything(), kind_of(Hash)).and_return("")
  end

  describe "POST create" do

    describe "with valid params" do
#      Usuario.stub!(:find_by_ci).and_return(mock_model(Usuario))
      it "assigns a newly created registro as @registro" do
        @m = mock_model(Registro, :save => true)
        post :create, :registro => {:these => 'params'}
        assigns[:registro].should_not equal(@m)
      end

      it "Debe retornar a new" do
        stubs_create()
        post :create, :registro => {}
        flash[:notice].should_not == nil
        response.should render_template("new")  
      end
    end

    # Stubs para poder crear
    def stubs_create_wrong()
      Usuario.stub!(:find_by_ci).with(anything()).and_return(nil)
      Registro.stub!(:new).and_return(mock_registro())
      I18n.stub!(:l).with(anything(), kind_of(Hash)).and_return("")
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved registro as @registro" do
        stubs_create_wrong()
        post :create, :registro => {:these => 'params'}
        assigns[:registro].should equal(mock_registro)
      end

      it "re-renders the 'new' template" do
        Registro.stub!(:new).and_return(mock_registro(:save => false))
        post :create, :registro => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested registro" do
        Registro.should_receive(:find).with("37").and_return(mock_registro)
        mock_registro.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :registro => {:these => 'params'}
      end

      it "assigns the requested registro as @registro" do
        Registro.stub!(:find).and_return(mock_registro(:update_attributes => true))
        put :update, :id => "1"
        assigns[:registro].should equal(mock_registro)
      end

      it "redirects to the registro" do
        Registro.stub!(:find).and_return(mock_registro(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(registro_url(mock_registro))
      end
    end

    describe "with invalid params" do
      it "updates the requested registro" do
        Registro.should_receive(:find).with("37").and_return(mock_registro)
        mock_registro.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :registro => {:these => 'params'}
      end

      it "assigns the registro as @registro" do
        Registro.stub!(:find).and_return(mock_registro(:update_attributes => false))
        put :update, :id => "1"
        assigns[:registro].should equal(mock_registro)
      end

      it "re-renders the 'edit' template" do
        Registro.stub!(:find).and_return(mock_registro(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested registro" do
      Registro.should_receive(:find).with("37").and_return(mock_registro)
      mock_registro.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the registros list" do
      Registro.stub!(:find).and_return(mock_registro(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(registros_url)
    end
  end

end
