defmodule Timeline.Mixfile do
  use Mix.Project

  def project do
    [app: :timeline,
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
    [mod: {Timeline, []},
     applications: [:phoenix, :cowboy, :logger, :ecto, :httpoison]]
  end

  # Specifies your project dependencies
  #
  # Type `mix help deps` for examples and options
  defp deps do
    [{:phoenix, github: "phoenixframework/phoenix"},
     {:cowboy, "~> 1.0"},
     {:postgrex, "~> 0.8.0"},
     {:ecto, github: "elixir-lang/ecto"},
     {:httpoison, "~> 0.6"},
     {:oauth2, github: "tony612/oauth2", branch: "change-plug-dep-version"},
     {:plug, "~> 0.11.0"},
     {:exjsx, "~> 3.1.0"},
     {:timex, "~> 0.13.3"}]
  end
end
