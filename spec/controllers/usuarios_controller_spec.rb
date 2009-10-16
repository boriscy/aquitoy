require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UsuariosController do

  before(:each) do
    @us = mock("hola", :record => mock_usuario)
    UsuarioSession.stub(:find).and_return(@us)
  end

  def mock_usuario(stubs={})
    @mock_usuario ||= mock_model(Usuario, stubs)
  end

  def mock_paginate(page)
    @mock_paginate ||= {}
    @mock_paginate[page] = mock_model(Usuario, :id => page)
    Usuario.stub!(:paginate).with({:page => kind_of(Fixnum), :order => anything()}).and_return([@mock_paginate[page]])
  end

  describe "GET index" do
    it "assigns all usuarios as @usuarios" do
      Usuario.stub!(:paginate).with(kind_of(Hash)).and_return([mock_usuario])
      get :index
      assigns[:usuarios].should == [mock_usuario]
    end

    it "debe paginar" do
      # Usuario.stub!(:paginate).and_return([mock_usuario()])
      @mock_paginate = mock_model(Usuario, :id => 1)
      (1..3).each do |page|
         get :index, :page => page
         assigns[:page].should == page.to_s
      end
    end
  end

  describe "GET show" do
    it "assigns the requested usuario as @usuario" do
      @usuario = Usuario.stub!(:find).with("37").and_return(mock_usuario(:id => 37))
      @usuario.stub!(:registros_ordenados).with(kind_of(Hash)).and_return({})
      get :show, :id => "37"
      assigns[:usuario].should equal(mock_usuario)
    end
  end

  describe "GET new" do
    it "assigns a new usuario as @usuario" do
      Usuario.stub!(:new).and_return(mock_usuario)
      get :new
      assigns[:usuario].should equal(mock_usuario)
    end
  end

  describe "GET edit" do
    it "assigns the requested usuario as @usuario" do
      Usuario.stub!(:find).with("37").and_return(mock_usuario)
      get :edit, :id => "37"
      assigns[:usuario].should equal(mock_usuario)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created usuario as @usuario" do
        @m = mock_model(Usuario, :save => true)
        Usuario.stub!(:new).with(kind_of(Hash)).and_return(@m)
        post :create, :usuario => {'these' => 'params'}
        assigns[:usuario].should equal(@m)
      end

      it "redirects to the created usuario" do
        @m = mock_model(Usuario, :save => true)
        Usuario.stub!(:new).and_return(@m)
        post :create, :usuario => {}
        response.should redirect_to(usuario_url(@m))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved usuario as @usuario" do
        @m = mock_model(Usuario, :save => true)
        Usuario.stub!(:new).with({'these' => 'params'}).and_return(@m)
        post :create, :usuario => {:these => 'params'}
        assigns[:usuario].should equal(@m)
      end

      it "re-renders the 'new' template" do
        @m = mock_model(Usuario, :save => false)
        Usuario.stub!(:new).and_return(@m)
        post :create, :usuario => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested usuario" do
        Usuario.should_receive(:find).with("37").and_return(mock_usuario)
        mock_usuario.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :usuario => {:these => 'params'}
      end

      it "assigns the requested usuario as @usuario" do
        @m = mock_model(Usuario, :update_attributes => true)
        Usuario.stub!(:find).and_return(@m)
        put :update, :id => "1"
        assigns[:usuario].should equal(@m)
      end

      it "redirects to the usuario" do
        @m = mock_model(Usuario, :update_attributes => true)
        Usuario.stub!(:find).and_return(@m)
        put :update, :id => "1"
        response.should redirect_to(usuario_url(@m))
      end
    end

    describe "with invalid params" do
      it "updates the requested usuario" do
        Usuario.stub!(:find).with("37").and_return(mock_usuario)
        Usuario.should_receive(:find).with("37").and_return(mock_usuario)
        mock_usuario.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :usuario => {:these => 'params'}
      end

      it "assigns the usuario as @usuario" do
        @m = mock_model(Usuario, :update_attributes => false)
        Usuario.stub!(:find).and_return(@m)
        put :update, :id => "1"
        assigns[:usuario].should equal(@m)
      end

      it "re-renders the 'edit' template" do
        @m = mock_model(Usuario, :update_attributes => false)
        Usuario.stub!(:find).and_return(@m)
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested usuario" do
      @m = mock_model(Usuario, :destroy => true, :id => 37)
      Usuario.stub!(:find).with("37").and_return(@m)
      delete :destroy, :id => "37"
    end

    it "redirects to the usuarios list" do
      Usuario.stub!(:find).and_return(mock_usuario(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(usuarios_url)
    end
  end

end
