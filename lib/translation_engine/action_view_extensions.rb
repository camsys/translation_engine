module ActionViewExtensions

  extend ActiveSupport::Concern

  def translate_helper_translate(key_param)
  	locale = extract_locale_from_subdomain
  	translation_records = Translation.where("key = ? AND locale = ?", key_param, locale)
  	#should add a Honeybadger call if multiple records returned.
  	translation_records.count > 0 ? translation_text = translation_records[0].value : translation_text = "Translation not found"
  	return translation_text
  end

  def extract_locale_from_subdomain
  	parsed_locale = request.fullpath.split("/")[1]
	I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : ""
  end

end