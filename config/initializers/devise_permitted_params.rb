module DevisePermittedParams
  extend ActiveSupport::Concern

  included do
    before_filter :configure_permitted_parameters
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |user|
      user.permit(:name, :email, :password)
    end
  end
end

DeviseController.send :include, DevisePermittedParams
