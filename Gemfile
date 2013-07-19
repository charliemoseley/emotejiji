source 'https://rubygems.org'

# Rails Core
gem 'rails'
gem 'sass-rails'
gem 'uglifier'
gem 'coffee-rails'
gem 'jquery-rails'
gem 'bcrypt-ruby'

# Architectural
gem 'pg'
gem 'rack-cors'

# API
gem 'grape'
gem 'grape-entity'
gem 'hashie'

group :development, :test do
  gem 'minitest-rails'
  gem 'dotenv-rails'
end

group :test do
  gem 'fabrication'
  gem 'faker'
end

group :production do
  gem 'rails_12factor'
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end