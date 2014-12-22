defmodule Fawlty.Endpoint do
  use Phoenix.Endpoint, otp_app: :fawlty

  plug Plug.Static,
  at: "/", from: :fawlty

  plug Plug.Logger

  # Code reloading will only work if the :code_reloader key of
  # the :phoenix application is set to true in your config file.
  plug Phoenix.CodeReloader

  plug Plug.Parsers,
  parsers: [:urlencoded, :multipart, :json],
  pass: ["*/*"],
  json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  plug Plug.Session,
  store: :cookie,
  key: "_fawlty_key",
  signing_salt: "juuOotv6",
  encryption_salt: "hBz6paFg"

  plug :router, Fawlty.Router

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Fawlty.Endpoint.config_change(changed, removed)
    :ok
  end
end
