defmodule MusicBot.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {MusicBot.BotSupervisor, []},
      MusicBot.Repo
    ]

    opts = [strategy: :one_for_one, name: MusicBot.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
