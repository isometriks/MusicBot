import Config

config :musicbot,
  ecto_repos: [MusicBot.Repo],
  bot_id: 981_344_600_126_029_834

config :musicbot, MusicBot.Repo,
  database: "musicbot_repo",
  username: "postgres",
  password: "postgres",
  hostname: "db"
