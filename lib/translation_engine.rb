require "translation_engine/version"
require 'translation_engine/action_view_extensions'


#refactor these includes at some point, if possible
require 'tasks/database_tasks'
require 'tasks/install'

module TranslationEngine

  class Engine < ::Rails::Engine

    engine_name 'translation_engine'
    
  end

  def self.translate_text(key_param, *interpolations)
    
    return translate_text_with_tooltip(key_param, *interpolations).html_safe

  end

  def self.translate_text_with_tooltip(key_param, *interpolations)

    #TAGS MODE
    return "[" + key_param.to_s + "]" if I18n.locale == :tags

    translation = build_translation(key_param, interpolations)
    tooltip_translation = build_translation(key_param.to_s + "_help", interpolations)
    tooltip_translation_with_wrapper = "<i class='fa fa-question-circle fa-2x pull-right label-help' style='margin-top:-4px;' title data-content='#{tooltip_translation}' tabindex='0'></i>" if !tooltip_translation.include? "Translation key not found"
    return translation.html_safe + tooltip_translation_with_wrapper.html_safe if !tooltip_translation.include? "Translation key not found"
    return translation.html_safe
  end

  def self.build_translation(key_param, *interpolations)
    
    begin

    #PROCESS INTERPOLATIONS *args
    while interpolations.class == Array
      interpolations = interpolations[0]
    end

    translation_key = nil 

    #KEY
    translation_key_records = TranslationKey.where("name = ?",key_param.to_s)
    if translation_key_records.count > 0
      translation_key = translation_key_records.first
    else
      #check for plural translation keys
      if interpolations.present? && interpolations[:count].present?
        is_singular = (interpolations[:count].to_i == 1) 
        is_singular ? translation_suffix = ".one" : translation_suffix = ".other"
        one_other_match_keys = TranslationKey.where("name like ?", key_param.to_s + "#{translation_suffix}")
        translation_key = one_other_match_keys.first if one_other_match_keys.count > 0
      end
    end

    return "Translation key not found = #{key_param}" if translation_key.blank?

    #LOCALE
    locale_id = Locale.where("name = ?",I18n.locale).first.id

    #TRANSLATION
    translation_records = Translation.where("translation_key_id = ? AND locale_id = ?", translation_key.id, locale_id)
    translation_records.count > 0 ? translation_text = translation_records.first.value : translation_text = "Translation not found: key = #{key_param}"

    #INTERPOLATIONS
    if interpolations.present?
      interpolations.keys.each do |interpolation_key|
        formatted_interpolation_key = "%{#{interpolation_key}}"
        translation_text.sub! formatted_interpolation_key, interpolations[interpolation_key].to_s if translation_text.sub!(formatted_interpolation_key, interpolations[interpolation_key].to_s).present?
      end
    end

    return translation_text.html_safe

    rescue => e
      Rails.logger.info "Translation Error"
      Rails.logger.info e
      Rails.logger.info 'key_param was: ' + key_param
      return "Translation not found: key = " + key_param
    end

  end

  #############################

  def self.translate_array array_of_keys
    array_of_translations_to_return = []
    array_of_keys.each do |key|
      array_of_translations_to_return.push(translate_text(key))
    end
    array_of_translations_to_return
  end

  def self.show_translation_item?(key_param)
    begin

      #check for tags mode
      return true if I18n.locale == :tags

      translation_key_id = TranslationKey.where("name = ?",key_param).first.id
      locale_id = Locale.where("name = ?",I18n.locale).first.id
      translation_records = Translation.where("translation_key_id = ? AND locale_id = ?", translation_key_id, locale_id)
      #should add a Honeybadger call if multiple records returned.
      translation_records.count > 0 ? translation_found = true : translation_found = false
      return translation_found
    rescue => e
      return false
    end
    
  end

  def self.translation_exists?(key_param)
    begin
      translation_key_id = TranslationKey.where("name = ?",key_param).first.id
      locale_id = Locale.where("name = ?",I18n.locale).first.id
      translation_records = Translation.where("translation_key_id = ? AND locale_id = ?", translation_key_id, locale_id)
      #should add a Honeybadger call if multiple records returned.
      translation_records.count > 0 ? translation_found = true : translation_found = false
      return translation_found
    rescue => e
      return false
    end
  end

  #oneclick_short %A, %B %-d
  #oneclick_long %A, %B %-d %Y

  def self.localize_date_short_format(date_param) 
    begin
      return I18n.l date_param, :format => "%A, %B %-d"
    rescue => e
      return "Error localizing date ({#e})"
    end
  end

  def self.localize_date_long_format(date_param)
    begin
      return I18n.l date_param, :format => "%A, %B %-d %Y"
    rescue => e
      return "Error localizing date ({#e})"
    end
  end

  def self.localize_time(time_param)
    begin
      return I18n.l time_param, :format => "%-I:%M %p"
    rescue => e
      return "Error localizing time ({#e})"
    end
  end

  def self.available_locales
    begin
      s = '(' + (I18n.available_locales + [:tags]).join('|') + ')'
      %r{#{s}}
    rescue Exception => e
      Rails.logger.info "Exception #{e.message} during oneclick_available_locales"
      puts "Exception #{e.message} during oneclick_available_locales"
      %r{en}
    end
  end

end

#Include as view helper
ActionView::Base.send :include, ActionViewExtensions