# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :consumer_edge,
  ecto_repos: [ConsumerEdge.Repo]

# Configures the endpoint
config :consumer_edge, ConsumerEdgeWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "VYwJrzRPYQYejJ3jwGBTwUFeaT1O5C7YguSptz80Pg3FUmTjPwnUYxO60zpnCFOz",
  render_errors: [view: ConsumerEdgeWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: ConsumerEdge.PubSub,
  live_view: [signing_salt: "ZbwhW+4T"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Use Pow for user authentication
config :consumer_edge, :pow,
  user: ConsumerEdge.Users.User,
  repo: ConsumerEdge.Repo

# Customize Pow templates
config :consumer_edge, :pow,
  user: ConsumerEdge.Users.User,
  repo: ConsumerEdge.Repo,
  web_module: ConsumerEdgeWeb

# Add Nebulex for caching
config :consumer_edge, ConsumerEdge.Cache,
  gc_interval: 86_400_000 #=> 1 day

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
