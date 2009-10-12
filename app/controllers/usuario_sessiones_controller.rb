class UsuarioSessionesController < ApplicationController
  # before_filter :verificar_permiso, :except => [:new, :create]

  def show
    @usuario_session = UsuarioSession.find(params[:id])
  end
  
  def new
    @usuario_session = UsuarioSession.new
  end
  
  def create
    @usuario_session = UsuarioSession.new(params[:usuario_session])
    if @usuario_session.save
      flash[:notice] = "Sistema de registro."
      redirect_to usuarios_url
    else
      flash[:notice] = "Usuario y/o Contraseña Incorrectos."
      render :action => 'new'
    end
  end
  
  def destroy
    @usuario_session = UsuarioSession.find(params[:id])
    @usuario_session.destroy
    flash[:notice] = "Usted Salio del Sistema."
    redirect_to login_url
  end

end
