class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  ensure_security_headers # See more: https://github.com/twitter/secureheaders

end
