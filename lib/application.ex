defmodule MusicBot.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    bot_options = %{
      consumer: MusicBot.BotConsumer,
      intents: [
        :direct_messages,
        :guild_messages,
        :message_content,
        :guild_message_reactions,
      ],
      wrapped_token: fn -> System.fetch_env!("TOKEN") end
    }

    children = [{Nostrum.Bot, bot_options}, MusicBot.Repo]
    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
