require "translation_engine/version"
require 'translation_engine/action_view_extensions'
require 'tasks/load_locales'

module TranslationEngine

  class Engine < ::Rails::Engine
    
    initializer :append_migrations do |app|
      unless app.root.to_s.match root.to_s
        config.paths["db/migrate"].expanded.each do |expanded_path|
          app.config.paths["db/migrate"] << expanded_path
        end
      end
    end
  end

end

#Include as view helper
ActionView::Base.send :include, ActionViewExtensions