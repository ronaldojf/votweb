module IndexTableFilters
  extend ActiveSupport::Concern
  include NgTableHelper

  included do
    before_action :filters, only: [:index]
  end

  private

  def filters
    @page = get_controller_config(:page) || 1
    @count = get_controller_config(:count) || Kaminari.config.default_per_page
    @sorting = get_controller_config(:sorting) || {}
    @filter = get_controller_config(:filter) || {general: ""}

    @config = {
      page: @page,
      sorting: @sorting,
      filter: @filter,
      count: @count
    }
  end
end
