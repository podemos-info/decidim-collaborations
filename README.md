# Decidim::Collaborations
This rails engine implements a Decidim feature that allows to the administrators to
configure crowfunding campaigns for a participatory space.

## Usage

This plugin provides:

* A CRUD engine to manage crowfunding campaigns.

* Public views for for crowfunding campaigns via a menu inside each participatory space.

* An interface with Census API.

* Rake tasks necessary to automatize recurrent payments.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'decidim-collaborations'
```

And then execute:
```bash
$ bundle
$ bundle exec rails decidim_collaborations:install:migrations
$ bundle exec rails db:migrate
$ bundle exec rails generate iban_bic:install
$ bundle exec rails db:migrate
$ bundle exec rails iban_bic:load_data
```

## Tests

In order to execute the tests data from iban_bic gem must be populated as well:

```bash
$ bundle exec rails db:migrate RAILS_ENV=test
$ bundle exec rails iban_bic:load_data RAILS_ENV=test
```

## Docker & Docker compose

This engine is supplied with Docker compose files. If you want to use them you need to
check the *spec/decidim_dummy_app/database.yml* and adjust the database settings:

```yaml
default: &default
  adapter: postgresql
  encoding: unicode
  # For details on connection pooling, see rails configuration guide
  # http://guides.rubyonrails.org/configuring.html#database-pooling
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  host: <%= ENV.fetch("DATABASE_HOST") { "db" } %>
  username: <%= ENV.fetch("DATABASE_USERNAME") { "admin" } %>
  password: <%= ENV.fetch("DATABASE_PASSWORD") { "admin" } %>
``` 
 
If you desire to use different settingsyou need to check the 
Docker compose settings and adjust the setup of the PostgreSQL
image.

Finally remember that the Docker file do not includes any command relative to the 
database setup. Due to this limitation, the first time that you execute
the app you must execute the following commands:

```bash
$ docker-compose run web bash
$ cd spec/decidim_dummy_app
$ bundle exec rails db:create
$ bundle exec rails db:migrate
$ bundle exec rails db:seed
```

## Rake tasks

This engine provides the following rake tasks:

### decidim_collaborations:recurrent_collaborations 

This task collects all recurrent collaborations that need to be renewed. Ideally it
should be automatically executed at least once per month.

## License
This engine is distributed under the GNU AFFERO GENERAL PUBLIC LICENSE.
