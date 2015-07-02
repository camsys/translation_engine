module ActionViewExtensions

  extend ActiveSupport::Concern

  def translate_helper(key_param, *interpolations)
    return TranslationEngine.translate_text(key_param, interpolations)
  end

  def translate_array_helper(array_of_keys)
    return TranslationEngine.translate_array(array_of_keys)
  end

end