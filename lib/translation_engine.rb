require "translation_engine/version"
require 'translation_engine/action_view_extensions'

#refactor these includes at some point, if possible
require 'tasks/database_tasks'

module TranslationEngine

  class Engine < ::Rails::Engine

    engine_name 'translation_engine'
    
  end

  def self.translate_text(key_param, *interpolations)
  	begin

      debugger

      #TAGS MODE
      return "[" + key_param.to_s + "]" if I18n.locale == :tags

      #PROCESS INTERPOLATIONS *args
      interpolations = interpolations[0] if interpolations.class == Array
      interpolations = interpolations[0] if interpolations.class == Array

      #KEY
	    translation_key_records = TranslationKey.where("name = ?",key_param.to_s)
      if translation_key_records.count > 0
        translation_key = translation_key_records.first
      else
        #check for plural translation keys
        is_singular = (interpolations[:count].to_i == 1) if interpolations[:count].present?
        is_singular ? translation_suffix = ".one" : translation_suffix = ".other"
        one_other_match_keys = TranslationKey.where("name like ?", key_param.to_s + "#{translation_suffix}")
        translation_key = one_other_match_keys.first if one_other_match_keys.count > 0
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
      puts "Translation Error"
      puts e
      return "Translation not found: key = #{key_param}"
    end

  end

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

end

#Include as view helper
ActionView::Base.send :include, ActionViewExtensions