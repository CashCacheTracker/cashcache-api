source 'https://rubygems.org'

# Core rails
gem 'rails', '>= 5.0.0.rc1', '< 5.1'
gem 'puma', '~> 3.0'

# API-level
gem 'rack-cors'
gem 'jsonapi-resources', github: 'cerebris/jsonapi-resources'

# DB
gem 'pg'
gem 'activerecord-postgis-adapter'
gem 'scenic'

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'rspec-rails', '3.5.0'
  gem 'factory_girl_rails'
end

group :development do
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

ruby '2.3.1'
