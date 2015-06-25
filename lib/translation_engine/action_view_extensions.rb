module ActionViewExtensions

  extend ActiveSupport::Concern

  def translate_helper(key_param, *interpolations)
    begin
      return TranslationEngine.translate_text(key_param, interpolations)
    rescue err
      return "Translation not found: key = #{key_param}"
    end
  end

end