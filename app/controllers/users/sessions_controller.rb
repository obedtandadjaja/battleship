class Users::SessionsController < Devise::SessionsController
# before_filter :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    super
    current_or_guest_user
  end

  # DELETE /resource/sign_out
  def destroy
    if current_user
      super
    elsif guest_user
      guest_user(with_retry = false).reload.try(:destroy)
      session[:guest_user_id] = nil
    end
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.for(:sign_in) << :attribute
  # end
end
