# TranslationEngine

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'translation_engine', github: 'camsys/translation_engine'
```

And then execute:

    $ bundle

## Usage

1. Run rake translation_engine:load_locales to load database from files
1. rake translation_engine:implement_new_database_schema (To add locale and key tables then add foreign keys to Translation table)
1. rake translation_engine:migrate_existing_translation_data
1. To enable editing in your app, mount the translation_engine routes in your routes.rb file: mount TranslationEngine::Engine => "/translation_engine"

## Contributing

1. Fork it ( https://github.com/[my-github-username]/translation_engine/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request