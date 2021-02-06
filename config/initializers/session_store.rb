# Be sure to restart your server when you modify this file.

if Rails.env == "production"
  #Rails.application.config.session_store :cookie_store, key: "_RailsUserProfile_session", domain: "uns1.herokuapp.com", same_site: :none, secure: true
  Rails.application.config.session_store :cookie_store, key: "_RailsUserProfile_session", domain: "uns-production.herokuapp.com", same_site: :none#, secure: true
elsif Rails.env == "staging"
  Rails.application.config.session_store :cookie_store, key: "_RailsUserProfile_session", domain: "uns-staging.herokuapp.com", same_site: :none#, secure: true
elsif Rails.env == "testing"
  Rails.application.config.session_store :cookie_store, key: "_RailsUserProfile_session", domain: "uns-testing.herokuapp.com", same_site: :none#, secure: true
else
  Rails.application.config.session_store :cookie_store, key: '_RailsUserProfile_session_dev'
end
