defmodule MusicBot.Repo do
  use Ecto.Repo,
    otp_app: :musicbot,
    adapter: Ecto.Adapters.Postgres
end
