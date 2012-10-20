class UsersController < ApplicationController
before_filter :signed_in_user, only: [:edit, :update]

  def show
    @user = User.find(params[:id]) #on create, @user is passed to show, 
    #but I think rails still looks up @user with @user.id. 
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"# these flash styles are in Bootstrap CSS. 
      redirect_to @user #redirect to user_path (users/show/) with @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

    private

    def signed_in_user
      redirect_to signin_url, notice: "Please sign in." unless signed_in?
      #shortcut for setting flash[:notice], (works for the :error key, but not for :success.)
    end
  
end