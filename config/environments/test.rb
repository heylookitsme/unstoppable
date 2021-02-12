Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # The test environment is used exclusively to run your application's
  # test suite. You never need to work with it otherwise. Remember that
  # your test database is "scratch space" for the test suite and is wiped
  # and recreated between test runs. Don't rely on the data there!
  config.cache_classes = true

  # Do not eager load code on boot. This avoids loading your whole application
  # just for the purpose of running a single test. If you are using a tool that
  # preloads Rails for running tests, you may have to set it to true.
  config.eager_load = false

  # Configure public file server for tests with Cache-Control for performance.
  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    'Cache-Control' => "public, max-age=#{1.hour.to_i}"
  }

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Raise exceptions instead of rendering exception templates.
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment.
  config.action_controller.allow_forgery_protection = false

  # Store uploaded files on the local file system (see config/storage.yml for options)
  config.active_storage.service = :google

 # Mount Action Cable outside main process or domain
  # config.action_cable.mount_path = nil
   config.action_cable.url = 'wss://uns1.herokuapp.com/cable'
   #config.web_socket_server_url = "ws://uns1.herokuapp.com/cable" 
   #config.action_cable.allowed_request_origins = [ 'https://shardax-unstoppable-ui.netlify.app', /http:\/\/example.*/ ]
   config.action_cable.allowed_request_origins = [ 'https://shardax-unstoppable-ui.netlify.app', 'http://localhost:3000']


  config.action_mailer.perform_caching = false

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  config.action_mailer.delivery_method = :smtp
  # Print deprecation notices to the stderr.
  config.active_support.deprecation = :stderr

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true



  ActionMailer::Base.smtp_settings = {
  domain: 'gmail.com',
  address:        "smtp.sendgrid.net",
  port:            587,
  authentication: :plain,
  user_name:      'apikey',
  password:       ENV['SENDGRID_API_KEY']
}

  config.action_mailer.default_url_options = { host: 'http://uns-test.herokuapp.com' }
end
