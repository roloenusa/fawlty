# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the router
config :fawlty, Fawlty.Endpoint,
  url: [host: "localhost"],
  http: [port: System.get_env("PORT")],
  https: false,
  secret_key_base: "KmRa7cnm/YeosYqYN9kMbRoYyqUUpMOjqWkKgcMoyhhLT7mrMKJXUlDu4YnX2nVhtjaWxIoBhkwTM5NrpbpepQ==",
  catch_errors: true,
  debug_errors: false,
  error_controller: Fawlty.PageController

# Session configuration
config :fawlty, Fawlty.Endpoint,
  session: [store: :cookie,
            key: "_fawlty_key"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :fawlty, :oauth2ex,
  id:            "google id",
  secret:        "google secret",
  authorize_url: "https://accounts.google.com/o/oauth2/auth",
  token_url:     "https://accounts.google.com/o/oauth2/token",
  scope:         "https://www.googleapis.com/auth/userinfo.email",
  callback_url:  "http://localhost:4000/sessions/oauth2callback"

config :fawlty, :google,
  email_url: "https://www.googleapis.com/oauth2/v2/userinfo"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
