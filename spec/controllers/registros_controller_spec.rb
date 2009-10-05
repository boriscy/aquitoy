require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RegistrosController do

  def mock_registro(stubs={})
    @mock_registro ||= mock_model(Registro, stubs)
  end

  describe "GET index" do
    it "assigns all registros as @registros" do
      Registro.stub!(:find).with(:all).and_return([mock_registro])
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

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created registro as @registro" do
        Registro.stub!(:new).with({'these' => 'params'}).and_return(mock_registro(:save => true))
        post :create, :registro => {:these => 'params'}
        assigns[:registro].should equal(mock_registro)
      end

      it "redirects to the created registro" do
        Registro.stub!(:new).and_return(mock_registro(:save => true))
        post :create, :registro => {}
        response.should redirect_to(registro_url(mock_registro))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved registro as @registro" do
        Registro.stub!(:new).with({'these' => 'params'}).and_return(mock_registro(:save => false))
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
