module ApplicationHelper
  def class_for_item_menu(controller_name)
    @controller_without_namespace ||= params[:controller].split('/').last
    (content_for(:highlight_controller) || @controller_without_namespace) == controller_name ? 'active' : nil
  end

  def class_for_subitem_menu(action_name)
    params[:action] == action_name ? 'active' : nil
  end

  def current_namespace
    current_user.is_a?(Administrator) ? :admin : current_user.class.to_s.downcase
  end

  # options = {
  #   icon:       'user',    # general alerts types with icon
  #   alert: {icon: 'user'}, # general alerts types with icon
  #   notice: {icon: 'user'} # general alerts types with icon
  # }
  #
  # the available types are notice and alert
  def flash_messages(options = {})
    options[:alert] ||= {}
    options[:notice] ||= {}

    render partial: "flash_messages", locals: { options: options }
  end

  # options = {
  #   fixed:      true,     # general alerts types without dismissable
  #   icon:       'user',   # general alerts types with icon
  #   alert: {                # alert type
  #     fixed:    true,         # specific alert type without dismissable
  #     icon:     'flag',       # specific alert type with icon
  #     show:     true,         # show a specific alert type
  #     message:  'Hi!'         # display a message to a specific alert type
  #   },
  #   html: {}
  # }
  #
  # the available types are notice, alert, warning and info
  def custom_flash_messages(options = {})
    options[:alert] ||= {}
    options[:notice] ||= {}
    options[:warning] ||= {}
    options[:info] ||= {}
    options[:html] ||= {}

    render partial: 'custom_flash_messages', locals: { options: options }
  end
end
