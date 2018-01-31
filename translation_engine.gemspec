# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'translation_engine/version'

Gem::Specification.new do |spec|
  
  spec.name          = "translation_engine"
  spec.version       = TranslationEngine::VERSION
  spec.authors       = ["Alex Bromley, Xudong Liu"]
  spec.email         = ["abromley@camsys.com, xudongliu@camsys.com"]
  spec.summary       = "Intended to provide translation services to Camsys apps, particularly OneClick and RidePilot."
  spec.description   = "Use I18n to provide translation services."
  spec.homepage      = "https://github.com/camsys/translation_engine"
  spec.license       = "MIT"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", "~>5.0"
  spec.add_dependency "sass-rails"
  spec.add_dependency "pg"
  spec.add_dependency "i18n-active_record"
  spec.add_dependency "honeybadger"
  spec.add_dependency "simple_form"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "factory_girl_rails"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "better_errors"

  spec.add_development_dependency "rspec-core"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "capybara"
  spec.add_development_dependency "cucumber-rails"
  spec.add_development_dependency "database_cleaner"

end