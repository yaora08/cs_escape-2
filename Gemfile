source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.6'

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem 'rails',      '6.0.4'
gem 'image_processing',           '1.12.2'
gem 'mini_magick',                '4.9.5'
gem 'active_storage_validations', '0.8.2'
gem 'bcrypt',         '3.1.13'
gem 'bootstrap-sass', '3.4.1'
gem 'puma',       '4.3.6'
gem 'sass-rails', '5.1.0'
gem 'webpacker',  '4.0.7'
gem 'turbolinks', '5.2.0'
gem 'jbuilder',   '2.9.1'
gem 'bootsnap',   '1.10.3', require: false
gem 'faker'
gem 'jquery-rails', '4.3.1'
gem 'pry-rails'
gem 'will_paginate',           '3.1.7'  
gem 'bootstrap-will_paginate', '1.0.0' 
gem 'kaminari'
gem 'htmlbeautifier'
gem 'carrierwave',             '1.2.2'  


group :production do
 gem 'fog', '1.42' 
 gem 'pg', '1.1.4'
end


group :development, :test do
  gem 'sqlite3', '1.4.2'
  gem 'byebug',  '11.0.1', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rails-controller-testing'
  gem 'rspec-rails', '~> 4.0.0.beta2'
  gem "factory_bot_rails", "~> 4.10.0"
end

group :development do
  gem 'web-console',           '4.0.1'
  gem 'listen',                '3.7.1'
  gem 'spring',                '2.1.0'
  gem 'spring-watcher-listen', '2.0.1'
  gem 'spring-commands-rspec'
end

group :test do
  gem 'capybara',           '3.28.0'
  gem 'selenium-webdriver', '3.142.4'
  gem 'webdrivers',         '4.1.2'
end

  gem 'devise'

# Windows ではタイムゾーン情報用の tzinfo-data gem を含める必要があります
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]