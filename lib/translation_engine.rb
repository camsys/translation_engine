require "translation_engine/version"
require 'translation_engine/action_view_extensions'
require 'tasks/load_locales'

module TranslationEngine

end

#Include as view helper
ActionView::Base.send :include, ActionViewExtensions