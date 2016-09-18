class Panel::BaseController < ApplicationController
  before_action :authenticate_councillor!

  layout 'panel/authenticated'
  helper_method :current_user

  def current_user
    current_councillor
  end
end
