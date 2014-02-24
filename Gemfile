source 'https://rubygems.org'

gem 'rails', '4.1.0.rc1'
gem 'pg'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0.rc1'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

gem 'polyamorous', github: 'activerecord-hackery/polyamorous'

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :test do
  gem 'minitest'
  gem 'webmock'
  gem 'database_cleaner'
  gem 'rake'
  gem 'rubysl-securerandom'
end

group :development, :test do
  gem 'rspec-rails', '2.14.0'
  gem 'factory_girl_rails', '4.2.0'
  gem 'watchr'
  gem 'debugger'
  gem 'faker'
end

group :development do
  gem 'spring'
  gem 'travis-lint'
end

group :development, :production do
  gem 'thin'
  gem 'turbolinks'
end

group :production do
  gem 'rails_12factor'
end

# For Static Assets and Logging
gem 'haml', '~> 4.0'
gem 'devise', '~> 3.2'
gem 'activeadmin', github: 'gregbell/active_admin'

gem "formtastic", github: "justinfrench/formtastic"
gem 'ransack', github: 'activerecord-hackery/ransack', branch: 'rails-4.1'
gem 'populator'
gem 'oj'
gem 'httparty'
gem 'active_model_serializers', '~> 0.8.0'
gem 'obscenity'
gem 'cancan'
gem 'hstore_accessor'

