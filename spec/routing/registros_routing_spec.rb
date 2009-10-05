require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RegistrosController do
  describe "route generation" do
    it "maps #index" do
      route_for(:controller => "registros", :action => "index").should == "/registros"
    end

    it "maps #new" do
      route_for(:controller => "registros", :action => "new").should == "/registros/new"
    end

    it "maps #show" do
      route_for(:controller => "registros", :action => "show", :id => "1").should == "/registros/1"
    end

    it "maps #edit" do
      route_for(:controller => "registros", :action => "edit", :id => "1").should == "/registros/1/edit"
    end

    it "maps #create" do
      route_for(:controller => "registros", :action => "create").should == {:path => "/registros", :method => :post}
    end

    it "maps #update" do
      route_for(:controller => "registros", :action => "update", :id => "1").should == {:path =>"/registros/1", :method => :put}
    end

    it "maps #destroy" do
      route_for(:controller => "registros", :action => "destroy", :id => "1").should == {:path =>"/registros/1", :method => :delete}
    end
  end

  describe "route recognition" do
    it "generates params for #index" do
      params_from(:get, "/registros").should == {:controller => "registros", :action => "index"}
    end

    it "generates params for #new" do
      params_from(:get, "/registros/new").should == {:controller => "registros", :action => "new"}
    end

    it "generates params for #create" do
      params_from(:post, "/registros").should == {:controller => "registros", :action => "create"}
    end

    it "generates params for #show" do
      params_from(:get, "/registros/1").should == {:controller => "registros", :action => "show", :id => "1"}
    end

    it "generates params for #edit" do
      params_from(:get, "/registros/1/edit").should == {:controller => "registros", :action => "edit", :id => "1"}
    end

    it "generates params for #update" do
      params_from(:put, "/registros/1").should == {:controller => "registros", :action => "update", :id => "1"}
    end

    it "generates params for #destroy" do
      params_from(:delete, "/registros/1").should == {:controller => "registros", :action => "destroy", :id => "1"}
    end
  end
end
