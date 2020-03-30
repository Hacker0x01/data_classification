# DataClassification

This gem is to help with classifying data in your database by adding smart comments to your columns in Rails. This brings
the following functionality to your Rails app:
 - a helper to allow migrations to easily add data classifications
 - a generator to create a migration that will add one or more data classifications to columns
 - a rake task to help you audit and set the data classifications for your columns

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'data_classification'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install data_classification

## Usage

## Migration Helper

One simple helper is available to set the classification on the column level:
```ruby
include DataClassification::Migrate
 
add_data_classification 'table_name', 'column_name', 'classification' 
```

This generates the SQL to add a column. In PostgreSQL, this is equivalent to:
```sql
COMMENT ON COLUMN schema.table_name.column_name IS '{"tags":["classification:confidential"]}';
```

### Migration Generator

You can view generators by running `bin/rails g`. The simple migration generator syntax is as follows:
```
bin/rails g data_classification <table>:<column>:<classification> <table>:<column>:<classification> ...
```

This will create a migration similar to the following:
```ruby
class CreateDataClassificationForArInternalMetadata < ActiveRecord::Migration[5.2]
  include DataClassification::Migration

  def up
    add_data_classification 'ar_internal_metadata', 'key', 'confidential'
  end

  def down
    fail ActiveRecord::IrreversibleMigration
  end
end
```

### Audit Data Classifications

It's tedious to go through and map out the table and column classifications. To help simplify the process, you can use this rake task:
```
bin/rake data_classification:bulk_classify
```

This walks through any uncommented table/columns and prompts on how to classify:
```
Table: users, Column: password
Data classification (public,operational,critical,confidential,personal,personal_sensitive, q(uit), n(ext) >
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Hacker0x01/data_classification. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/Hacker0x01/data_classification/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the DataClassification project's codebases, issue trackers, chat rooms, and mailing lists is expected to follow the [code of conduct](https://github.com/Hacker0x01/data_classification/blob/master/CODE_OF_CONDUCT.md).
