class ApplicationController < ActionController::Base
  before_action :authorize

  protected
    def authorize
      return true if User.none?
      found_user = User.find_by(id: session[:user_id])

      unless found_user
        redirect_to login_url, notice: "Please log in"
        return
      end

      if request.format == "text/html"
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
end
