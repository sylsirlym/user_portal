# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :user_portal,
  ecto_repos: [UserPortal.Repo]

# Configures the endpoint
config :user_portal, UserPortalWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "dK+scRuSSmxyYHLdpPveP7ZR1myLeyg21wqEBckFc8jaXgH/wFOiixzBf2MZmxTI",
  render_errors: [view: UserPortalWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: UserPortal.PubSub,
  live_view: [signing_salt: "358d6Mdx"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Use Mailer for Sending Emails
config :user_portal, UserPortal.Mailer,
       adapter: Swoosh.Adapters.Mailgun,
       api_key: "******************"

config :guardian, Guardian,
       allowed_algos: ["HS512"],
       verify_module: Guardian.JWT,
       issuer: "UserPortal",
       ttl: { 30, :days },
       allowed_drift: 2000,
       verify_issuer: true, # optional
       secret_key: System.get_env("GUARDIAN_SECRET") || "xx...xxxx",
       serializer: UserPortal.Web.GuardianSerializer

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
