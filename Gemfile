source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0'

# Use Puma as the app server
gem 'puma', '~> 3.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
gem 'rake'

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'cropper-rails'
gem 'rails-ujs'
source 'https://rails-assets.org' do
  gem 'rails-assets-tether', '>= 1.1.0'
end
gem 'jquery-turbolinks'

# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
gem 'redis'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'devise'
gem 'bootstrap' #, '~> 4.1.1'
gem 'bootstrap-sass' #, '3.3.7'
gem 'sprockets-rails'
gem 'devise-bootstrap-views', '~> 1.0'
gem 'paperclip'
gem 'dotenv-rails', :require => 'dotenv/rails-now'
gem "recaptcha", require: "recaptcha/rails"
gem 'simple_form'
gem 'carrierwave', '~> 1.0'
gem "mini_magick"
gem 'bootsnap'
gem 'sunspot_rails'
gem 'sunspot_solr' # optional pre-packaged Solr distribution for use in development. Please find a section below explaining other options for running Solr in production
gem 'remotipart', github: 'mshibuya/remotipart'
gem 'rails_admin', '>= 1.0.0.rc'
gem 'geocoder'
gem 'request_store'
gem 'geokit-rails'
gem 'mail', '~> 2.7'
gem 'wicked'
gem 'bootstrap-glyphicons'
gem 'validates_zipcode'
gem 'countries', :require => 'countries/global'
gem 'zip-codes'
gem 'mailboxer'
gem 'select_all-rails'
gem 'kaminari'
gem "google-cloud-storage", "~> 1.8", require: false
gem 'rb-readline'
gem 'popper_js'
gem 'email_verifier'
gem 'pg_search'
gem 'figaro'
gem 'chosen-rails'
gem 'rack-cors'
gem 'multi_json'
gem 'json'
gem 'config'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3', '~> 1.3.6'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :production do
  gem 'pg'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
