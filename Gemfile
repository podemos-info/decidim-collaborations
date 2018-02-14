# frozen_string_literal: true

source 'https://rubygems.org'

ruby RUBY_VERSION

gem "decidim", git: "https://github.com/decidim/decidim"
gem "decidim-census_connector", git: "https://github.com/podemos-info/decidim-module-census_connector"
gem "decidim-collaborations", path: "."

gem "puma", "~> 3.0"
gem "uglifier", "~> 4.1"

group :development, :test do
  gem "byebug", "~> 10.0", platform: :mri

  gem "decidim-dev", git: "https://github.com/decidim/decidim"
end

group :development do
  gem "faker", "~> 1.8"
  gem "letter_opener_web", "~> 1.3"
  gem "listen", "~> 3.1"
  gem "spring", "~> 2.0"
  gem "spring-watcher-listen", "~> 2.0"
  gem "web-console", "~> 3.5"
end
