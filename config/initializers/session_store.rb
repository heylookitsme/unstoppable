# Be sure to restart your server when you modify this file.

if Rails.env == "production"
  Rails.application.config.session_store :cookie_store, key: "_RailsUserProfile_session",domain: "uns1.herokuapp.com"
else
  Rails.application.config.session_store :cookie_store, key: '_RailsUserProfile_session'
end
