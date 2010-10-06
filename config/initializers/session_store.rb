# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_mstp_session',
  :secret      => '67b0b7e3cd9cdb53f015a243b9cb207fd6ffde8767831ed14712af8e24efe4743b67b095fef57020c5169c19cfd72b646885e2ba4c1b234fc905da9ae8236978'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
