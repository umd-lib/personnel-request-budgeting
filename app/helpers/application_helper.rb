module ApplicationHelper
  # Returns HTML content for a tooltip displaying the given translation key,
  # or nil if the translation key is not set.
  def help_text_icon(translation_key)
    help_text = raw t(translation_key, default: '')
    content_tag('i', '', { title: help_text, class: ['help-text-icon'] }, false) unless help_text.empty?
  end
end
