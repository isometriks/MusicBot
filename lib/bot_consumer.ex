defmodule MusicBot.BotConsumer do
  use Nostrum.Consumer

  alias Nostrum.Api
  alias MusicBot.Commands

  def start_link do
    Consumer.start_link(__MODULE__)
  end

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    message =
      case Api.get_channel_message(msg.channel_id, msg.id) do
        {:ok,
         %Nostrum.Struct.Message{
           content: content
         }} ->
          content

        _ ->
          ""
      end

    cond do
      true ->
        :ignore
    end
  end

  def handle_event({:READY, %Nostrum.Struct.Event.Ready{} = _event, _ws_state}) do
    Commands.command_list()
    |> Enum.map(fn command ->
      Api.create_guild_application_command("981363310882619462", command)
    end)
  end

  def handle_event(
        {:INTERACTION_CREATE,
         %Nostrum.Struct.Interaction{
           data: %{name: "idea", options: [%{name: "idea", value: idea}]}
         } = interaction, _ws_state}
      ) do
    MusicBot.Ideas.create(%{
      idea: idea,
      author: interaction.member.user.username,
      votes: 0,
      # for emoji reactions to work, gotta keep track of the message ID
      # we we want the reaction to be on the message sent by the user or the bot?
      src_id: interaction.id
    })

    Api.create_interaction_response(interaction, %{
      # ChannelMessageWithSource
      type: 4,
      data: %{
        content: "Idea added: " <> idea
      }
    })
  end

  def handle_event(
        {:INTERACTION_CREATE,
         %Nostrum.Struct.Interaction{
           data: %{name: "list"}
         } = interaction, _ws_state}
      ) do
    ideas =
      MusicBot.Repo.all(MusicBot.Schemas.Idea)
      |> Enum.map(fn idea ->
        "- " <> idea.idea
      end)
      |> Enum.join("\n")

    Api.create_interaction_response(interaction, %{
      # ChannelMessageWithSource
      type: 4,
      data: %{
        content: ideas
      }
    })
  end

  def handle_event(
    # trying to handle emoji reactions to add votes
    {:MESSAGE_REACTION_ADD,
  %Nostrum.Struct.Event.MessageReactionAdd{
emoji: 
message_id:

  }

  }}
  )

  # Default event handler, if you don't include this, your consumer WILL crash if
  # you don't have a method definition for each event type.
  def handle_event({event_name, _, _}) do
    event_name |> IO.inspect()
    :noop
  end
end
