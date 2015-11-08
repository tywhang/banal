source 'https://rubygems.org'

gem 'rails', '4.2.2'

gem 'puma'
gem 'rack-timeout'

gem 'pg'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'

gem 'jquery-rails'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'devise'

group :development, :test do
  gem 'byebug'
  gem 'web-console', '~> 2.0'
  gem 'spring'
  gem 'rspec-rails'

  # generate fake data in ex. seeds
  gem 'faker', github: 'stympy/faker' # need HEAD for Book.genre

  # Pry hooks into rspec much better, specifically it uses the same activerecord
  # transaction, so you can see what's actually going on.
  gem 'pry'
end

group :test do
  gem 'rspec-activemodel-mocks'

  # provides testing utilities for starting/stopping elasticsearch
  gem 'elasticsearch-extensions'
end

gem 'elasticsearch-rails'
gem 'elasticsearch-model'

gem 'rails_12factor', group: :production
