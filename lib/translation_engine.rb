require "translation_engine/version"
require 'translation_engine/action_view_extensions'

#refactor these includes at some point, if possible
require 'tasks/load_locales'
require 'tasks/database_tasks'

module TranslationEngine

  class Engine < ::Rails::Engine
    
  end

  def self.translate_text key_param

      locale = 'en'
      translation_records = Translation.where("key = ? AND locale = ?", key_param, locale)
      #should add a Honeybadger call if multiple records returned.
      translation_records.count > 0 ? translation_text = translation_records[0].value : translation_text = "Translation not found: key = #{key_param}"
      return translation_text

  end

end

#Include as view helper
ActionView::Base.send :include, ActionViewExtensions