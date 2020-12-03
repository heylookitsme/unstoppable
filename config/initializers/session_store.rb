# Be sure to restart your server when you modify this file.

if Rails.env == "production"
  #Rails.application.config.session_store :cookie_store, key: "_RailsUserProfile_session",domain: "uns1.herokuapp.com"
  Rails.application.config.session_store :cookie_store, key: "_RailsUserProfile_session", domain: "shardax-unstoppable-ui.netlify.app"
 
  #Rails.application.config.session_store :cookie_store, key: "_RailsUserProfile_session", domain: :all
else
  Rails.application.config.session_store :cookie_store, key: '_RailsUserProfile_session_dev'
end
