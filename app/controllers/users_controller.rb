class UsersController < Devise::RegistrationsController
  include DeviseUsersResources

  def new_with_registration_token
    @user = User.find_by(registration_token: params[:registration_token])
    if @user
      sign_in :user, @user, bypass: true
      flash[:notice] = "Please enter a password to register your account."
      render :edit
    else
      flash[:alert] = "Your registration token has expired"
      redirect_to root_path
    end
  end

  def update
    if params[:user][:registration_token]
      @user = User.find(params[:id])
      if @user.update(params.require(:user).permit(:password, :password_confirmation, :registration_token))
        flash[:notice] = "Registered successfully"
        @user.update(registration_token: "")
        Hour.set_registration_hour(@user)
        FairShareMailer.delay.send_registered_email(@user.id)
        redirect_to root_path
      else
        flash[:alert] = "Uh oh...something went wrong!"
        render :edit
      end
    else
      flash[:alert] = "Access denied"
      redirect_to root_path
    end
  end

  protected

  def update_resource(resource, params)
    resource.update_without_password(params)
  end
end
