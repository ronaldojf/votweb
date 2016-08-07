<% if namespaced? -%>
require_dependency "<%= namespaced_file_path %>/application_controller"
<% end -%>
<% module_namespacing do -%>
class <%= controller_class_name %>Controller < ApplicationController
  before_action :set_<%= singular_table_name %>, only: [:show, :edit, :update, :destroy]

  def index
    respond_to do |format|
      format.html { render :index }
      format.json do
        @<%= plural_table_name %> = scope_for_ng_table(<%= class_name %>)
                            .search(params[:filter].try(:[], :search_query).to_s)
      end
    end
  end

  def new
    @<%= singular_table_name %> = <%= orm_class.build(class_name) %>
  end

  def create
    @<%= singular_table_name %> = <%= orm_class.build(class_name, "#{singular_table_name}_params") %>
    @<%= orm_instance.save %>
    respond_with :admin, @<%= singular_table_name %>
  end

  def update
    @<%= orm_instance.update("#{singular_table_name}_params") %>
    respond_with :admin, @<%= singular_table_name %>
  end

  def destroy
    @<%= orm_instance.destroy %>
    respond_with @<%= singular_table_name %>, location: -> { admin_<%= index_helper %>_path }
  end

  private

  def set_<%= singular_table_name %>
    @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>
  end

  def <%= "#{singular_table_name}_params" %>
    <%- if attributes_names.empty? -%>
    params[:<%= singular_table_name %>]
    <%- else -%>
    params
      .require(:<%= singular_table_name %>)
      .permit(<%= attributes_names.map { |name| ":#{name}" }.join(', ') %>)
    <%- end -%>
  end
end
<% end -%>