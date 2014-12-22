use Mix.Config

config :fawlty, Fawlty.Endpoint,
  http: [port: System.get_env("PORT") || 4001],
  catch_errors: false
