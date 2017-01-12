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
    content_tag(
      :button,
      content_tag('i', '', { title: help_text, class: ['help-text-icon'] }, false),
      'type' => 'button',
      'class' => 'btn btn-xs btn-default',
      'data-toggle' => 'popover',
      'data-content' => help_text,
      'data-placement' => 'top'
    ) unless help_text.empty?
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

  # Returns style definitions for axlsx workbook formatting.
  #
  # @param [xlsx_package.workbook] object for creating the styles
  # @return [Hash] style definitions that can be used to format workbook
  # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
  def define_styles(wb)
    # Define style components
    title_font_size = 16
    header_font_size = 14
    summary_description_font_size = 14
    summary_result_font_size = 12
    title_font = { sz: title_font_size, b: true }
    header_font = { sz: header_font_size, b: true }
    summary_description_font = { sz: summary_description_font_size, b: true, i: true }
    summary_result_font = { sz: summary_result_font_size, b: true }
    currency_format = { format_code: '$#,##0.00' }
    top_border = { border: { style: :thick, color: '000000', name: :top, edges: [:top] } }
    bottom_border = { border: { style: :thick, color: '000000', name: :bottom, edges: [:bottom] } }

    # Style definitions
    styles = {}
    styles[:currency] = wb.styles.add_style(currency_format)
    styles[:extra_title] = wb.styles.add_style(title_font)
    styles[:title] = wb.styles.add_style title_font.merge(bg_color: 'FFFF00')
    styles[:header] = wb.styles.add_style header_font.merge(bg_color: 'D9D9D9')
    styles[:header_bottom_border] = wb.styles.add_style header_font.merge(bg_color: 'D9D9D9')
                                    .merge(bottom_border)
    styles[:summary_description] = wb.styles.add_style summary_description_font
    styles[:summary_result] = wb.styles.add_style summary_result_font.merge(currency_format)
                              .merge(bg_color: 'D9D9D9')
    styles[:summary_result_top_border] = wb.styles.add_style summary_result_font.merge(currency_format)
                                         .merge(bg_color: 'D9D9D9').merge(top_border)
    styles
  end
  # rubocop:enable Metrics/AbcSize,Metrics/MethodLength
end
