# TranslationEngine

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'translation_engine'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install translation_engine

## Usage

1. Run rake translation_engine:load_locales to load database from files
1. rake translation_engine:implement_new_database_schema (To add locale and key tables then add foreign keys to Translation table)

## Contributing

1. Fork it ( https://github.com/[my-github-username]/translation_engine/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
