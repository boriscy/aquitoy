# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_control_personal_session',
  :secret      => '1c88a00ea4a5820afc856999d666cec53c4de145228cc7bc7eab1a4fe3a0cca85a483ba43059befe0c133ab53b2d9a7eaca9b0cd0a52447801ad5d2afb740f2e'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
