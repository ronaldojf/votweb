class Admin::HomeController < Admin::BaseController
  skip_load_and_authorize_resource
end
