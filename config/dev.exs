use Mix.Config

config :timeline, Timeline.Endpoint,
  http: [port: System.get_env("PORT") || 4000],
  debug_errors: true,
  cache_static_lookup: false


config :timeline, Timeline.Repo,
  database: "timeline_development",
  username: "timeline",
  password: nil,
  hostname: "localhost"

# Enables code reloading for development
config :phoenix, :code_reloader, true

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"
