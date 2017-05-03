source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.0.2'

gem 'pg'

gem 'puma', '~> 3.0'

gem 'slim-rails'
gem 'skim'
gem 'sprockets', '3.6.3'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'therubyracer', '0.12.1', platforms: :ruby
gem 'devise'
gem 'jquery-rails'
gem 'turbolinks', '~> 5'
gem 'jquery-turbolinks'
gem 'jbuilder', '~> 2.5'
gem 'twitter-bootstrap-rails'
gem 'carrierwave'
gem 'remotipart'
gem "cocoon"
gem 'gon'
gem 'responders', '~> 2.0' 
gem 'omniauth'
gem 'omniauth-facebook'

group :development, :test do
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rspec-rails'
  gem 'capybara'
  gem 'launchy'
  gem 'rails-controller-testing'
  gem 'faker'
  gem 'factory_girl_rails'
  gem 'capybara-webkit', '= 1.1.0'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'rubocop', '~> 0.47.1', require: false
  gem 'guard-rspec',          require: false
  gem 'spring-commands-rspec'
end

group :test do
  gem 'shoulda-matchers'
  gem 'database_cleaner'
  gem 'fuubar'
end  

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
