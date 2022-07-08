import Config

config :musicbot,
  ecto_repos: [MusicBot.Repo]

config :musicbot, MusicBot.Repo,
  database: "musicbot_repo",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :nostrum,
  token: "OTgxMzQ0NjAwMTI2MDI5ODM0.G0yn0t.BnIAChG6rIgMAs8bBSy4u7RoktBoRzmSCnloKI",
  gateway_intents: :nonprivileged
