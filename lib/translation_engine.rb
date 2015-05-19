require "translation_engine/version"
require 'action_view_extensions'

module TranslationEngine

end

#Include as view helper
ActionView::Base.send :include, TranslationEngine::ActionViewExtensions