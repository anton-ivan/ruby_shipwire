class DistributorsController < ApplicationController
  before_action :login_required, only: [:show, :edit, :update]
  before_action :reset_password_required, except: [:edit, :update]

  def new
    @distributor = Distributor.new
  end
  
  def subregion_options
    render partial: 'subregion_select'
  end

  def create
    @distributor = Distributor.new(distributor_params)

    if @distributor.save
      DistributorMailer.new_distributor(@distributor).deliver!

      redirect_to confirmation_distributors_path
    else
      render new_distributor_path
    end
  end

  def show
    @distributor = current_distributor
    @order = @distributor.orders.build
    @credit_card = CreditCard.new

    Product.all.each do |p|
      @order.order_items<< OrderItem.new(product: p, quantity: 0)
    end
  end

  def edit
    @distributor = current_distributor
  end

  def update
    @distributor = current_distributor

    if @distributor.update_attributes(distributor_params)
      @distributor.update_attribute(:require_password_reset, false)
      redirect_to distributors_path
    else
      render :edit
    end
  end

  def confirmation
  end

  def login
    @distributor = Distributor.find_by_email(params[:email])
    if @distributor.present? && @distributor.authenticate(params[:password])
      session[:distributor_id] = @distributor.id

      redirect_to distributors_path
    else
      @distributor = Distributor.new if @distributor.nil?
      flash.now.alert = "Invalid email or password"
      render :new
    end
  end

  def logout
    reset_session
    redirect_to root_url
  end

  private
  def distributor_params
    params.require(:distributor).permit(:company_name, :country, :first_name, :last_name, :address1, :address2, :city, :state, :zip, :phone, :email, :password, :password_confirmation)
  end

  def current_distributor
    @current_distributor ||= Distributor.find(session[:distributor_id]) if session[:distributor_id]
  end

  def logged_in?
    current_distributor
  end

  def login_required
    redirect_to new_distributor_path unless logged_in?
  end

  def redirect_to_target_or_default(default, *args)
    redirect_to(session[:return_to] || default, *args)
    session[:return_to] = nil
  end

  def store_target_location
    # don't store the target location for SignUp and Login
    unless request.path == new_distributor_path
      session[:return_to] = request.url if request.get? && request.format == :html
    end
  end

  def reset_password_required
    if logged_in? && current_distributor.require_password_reset
      store_target_location
      redirect_to edit_distributors_path, :alert => 'You must update your password'
    end
  end
end
