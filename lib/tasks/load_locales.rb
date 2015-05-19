namespace :translation_engine do
  desc "Load database translations from config/locales/moved-to-db/*.yml files (idempotent)"
  task load_locales: :environment do
    Dir.glob('config/locales/moved-to-db/*').each do |file|
      puts "Loading locale file #{file}"
      I18n::Utility.load_locale file
    end
  end
end