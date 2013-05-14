class Spree::AddressesController < Spree::StoreController
  helper Spree::AddressesHelper
  rescue_from ActiveRecord::RecordNotFound, :with => :render_404
  load_and_authorize_resource :class => Spree::Address
  ssl_required

  def index
    redirect_to account_path
  end
  
  def show
    redirect_to account_path
  end

  def edit
    session["user_return_to"] = request.env['HTTP_REFERER']
    respond_to do |format|
      format.html
      format.json
    end
  end

  def new
    @address = Spree::Address.default
    respond_to do |format|
      format.html { render :new}
      format.json { render :edit}
    end
  end

  def update
    if @address.editable?
      address_to_edit = @address
      method = Proc.new {address_to_edit.update_attributes(params[:address])}
    else
      address_to_edit = @address.clone
      address_to_edit.attributes = params[:address]
      @address.update_attribute(:deleted_at, Time.now)
      method = Proc.new {address_to_edit.save()}
    end
    respond_to do |format|
      if method.call
        format.html do
          flash[:notice] = I18n.t(:successfully_updated, :resource => I18n.t(:address))
          redirect_back_or_default(account_path)
        end
        format.json {render :json => {:result => :ok, :address => address_to_edit.to_s} }
      else
        format.html {render :action => "edit"}
        format.json {render :json => {:result => :error } }
      end
    end
  end

  def create
    @address = Spree::Address.new(params[:address])
    @address.user = current_user
    respond_to do |format|
      if @address.save
        format.html do
          flash[:notice] = I18n.t(:successfully_created, :resource => I18n.t(:address))
          redirect_to account_path
        end
        format.json {render :json => {:result => :ok, :address => @address.to_s, :raw => @address} }
      else
        format.html {render :action => "new"}
        format.json {render :json => {:result => :error } }
      end
    end
  end

  def destroy
    @address.destroy

    flash[:notice] = I18n.t(:successfully_removed, :resource => t(:address))
    redirect_to(request.env['HTTP_REFERER'] || account_path) unless request.xhr?
  end
end
