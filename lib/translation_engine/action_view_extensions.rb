module ActionViewExtensions

  extend ActiveSupport::Concern

  def translate_helper(key_param, *interpolations)
    return TranslationEngine.translate_text(key_param, interpolations)
  end

  def translate_array_helper(array_of_keys)
    return TranslationEngine.translate_array(array_of_keys)
  end

  def links_to_each_locale(show_translations = false)

    links = []
    I18n.available_locales.each do |l|
      links << link_using_locale(l)
    end
    if show_translations
      links << link_using_locale(:tags)
    end

    return '' if links.size <= 1

    links.join(' | ').html_safe
    
  end

  def link_using_locale locale

    path = request.fullpath
    parts = path.split('/', 3)

    current_locale = I18n.available_locales.detect do |l|
      parts[1] == l.to_s
    end
    parts.delete_at(1) if current_locale or I18n.locale == :tags
    parts = parts.join('/')
    parts = '' if parts=='/'
    newpath = "/#{locale}#{parts}"

    if (newpath == path) or (newpath == "/#{I18n.locale}#{path}") or (newpath == "/#{I18n.locale}")
      TranslationEngine.translate_text("locales.#{locale}")
    else
      if locale == :tags
        link_to "Tags", newpath
      else
        link_to TranslationEngine.translate_text("locales.#{locale}"), newpath
      end
    end

  end

end