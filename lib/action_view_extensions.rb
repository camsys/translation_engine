require "translation_engine/version"

module TranslationEngine

  module ActionViewExtensions

	  def translate_helper_translate(key_param)
	  	locale = extract_locale_from_subdomain
	  	translation = Translation.where("key = ? AND locale = ?", key_param, locale)
	  	return translation[0].value if translation.count > 0
	  	return "Translation not found."
	  end

	  def extract_locale_from_subdomain
	  		parsed_locale = request.fullpath.split("/")[1]
			I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : ""
	  end

	  # ActionView::Helpers::TranslationHelper.class_eval do |variable|

	  # 	include TranslationEngine

	  # 	def translate key, *args
			# locale = extract_locale_from_subdomain
	  # 		translation = Translation.where("key = ? AND locale = ?", key_param, locale)
	  # 		return translation if translation.count > 0
	  # 		return "Translation not found."
	  # 	end
	  	
	  # end

  end

end