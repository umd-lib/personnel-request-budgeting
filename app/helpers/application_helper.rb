module ApplicationHelper
  def bootstrap_class_for(flash_type)
    { success: 'alert-success', error: 'alert-danger', alert: 'alert-warning',
      notice: 'alert-info' }[flash_type.intern] || flash_type.to_s
  end

  def flash_messages(_opts = {})
    flash.each do |msg_type, message|
      concat(content_tag(:div, message, class: "alert #{bootstrap_class_for(msg_type)} fade in") do
               concat content_tag(:button, 'x', class: 'close', data: { dismiss: 'alert' })
               concat message
             end)
    end
    nil
  end

  # @param [String, Symbol] i18n_key the key in the I18N translation file
  # @return [String, nil] the HTML content for a popover displaying text from
  #   the given translation key, or nil if the translation key is not set.
  def help_text_icon(i18n_key)
    help_text = safe_join [t(i18n_key, default: '')]
    unless help_text.empty?
      content_tag(
        :button,
        content_tag('i', '', { title: help_text, class: ['help-text-icon'] }, false),
        'type' => 'button',
        'class' => 'btn btn-xs btn-default',
        'data-toggle' => 'popover',
        'data-content' => help_text,
        'data-placement' => 'top'
      )
    end
  end

  # Returns confirmation prompt text for delete action on the given object.
  #
  # @param [Object] object the object being deleted
  # @return [String] representing the text to show in the confirmation dialog.
  def confirm_delete_text(object)
    description = object.description if object.respond_to?(:description)

    if description.nil?
      t('confirm_delete_prompt.default')
    else
      t('confirm_delete_prompt.with_description', description: description)
    end
  end
end
