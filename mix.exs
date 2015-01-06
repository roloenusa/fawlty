defmodule Fawlty.Mixfile do
  use Mix.Project

  def project do
    [app: :fawlty,
     version: "0.0.1",
     elixir: "~> 1.0",
     elixirc_paths: ["lib", "web"],
     compilers: [:phoenix] ++ Mix.compilers,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [mod: {Fawlty, []},
     applications: [
       :phoenix,
       :cowboy,
       :logger,
       :ecto,
       :postgrex,
       :oauth2ex
    ]]
  end

  # Specifies your project dependencies
  #
  # Type `mix help deps` for examples and options
  defp deps do
    [{ :phoenix, "~> 0.7"},
     { :cowboy, "~> 1.0"},
     { :ecto, "~> 0.2.0"},
     { :postgrex, "~> 0.6.0"},
     { :oauth2ex, github: "parroty/oauth2ex"},
     { :erlpass, github: "ferd/erlpass"}

    ]
  end
end
