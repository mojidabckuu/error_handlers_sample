# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :error_handler,
  ecto_repos: [ErrorHandler.Repo]

# Configures the endpoint
config :error_handler, ErrorHandlerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "CGLj6R1RmiMmXD3SJk+ZGGLisoVSH6XS9XwKFOvjIrGbIe+OOVAl8UTh6Uj60Nne",
  render_errors: [view: ErrorHandlerWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: ErrorHandler.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
