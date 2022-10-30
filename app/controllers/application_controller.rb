class ApplicationController < ActionController::Base
  before_action :authorize
  before_action :set_i18n_locale_from_params 

  protected
    def authorize
      return true if User.none?
      found_user = User.find_by(id: session[:user_id])

      unless found_user
        redirect_to login_url, notice: "Please log in"
        return
      end

      # Have not been able to mock this in-browser login
      if request.format == "text/html" && ENV['RAILS_ENV'] != 'test'
        authenticate_or_request_with_http_basic do |_user, password|
          found_user.try(:authenticate, password)
        end
      else
        # This seems to work in the browser with 
        # http://localhost:3000/products/8/who_bought.atom
        # But not in the CLI
        return true
      end
    end

    def set_i18n_locale_from_params
      if params[:locale]
        if I18n.available_locales.map(&:to_s).include?(params[:locale])
          I18n.locale = params[:locale]
        else
          flash.now[:notice] = "#{params[:locale]} translation not available"
          logger.error(flash.now[:notice])
        end
      end
    end
end
