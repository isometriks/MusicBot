defmodule MusicBot.BotConsumer do
  @behaviour Nostrum.Consumer

  alias Nostrum.Api
  alias MusicBot.Commands
  alias MusicBot.Ideas

  alias Nostrum.Struct.Event.MessageReactionAdd
  alias Nostrum.Struct.Event.MessageReactionRemove

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    _message =
      case Api.Message.get(msg.channel_id, msg.id) do
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
      ["1024715933845045329"]
      |> Enum.map(fn id ->
        Api.ApplicationCommand.create_guild_command(id, command)
      end)
    end)
  end

  def handle_event(
        {:INTERACTION_CREATE,
         %Nostrum.Struct.Interaction{
           data: %{name: "idea", options: [%{name: "idea", value: idea}]}
         } = interaction, _ws_state}
      ) do
    Api.Interaction.create_response(interaction, %{
      # ChannelMessageWithSource
      type: 4,
      data: %{
        content: "Thanks for the idea bb"
      }
    })

    {:ok, response} =
      Api.Message.create(
        interaction.channel_id,
        "#{interaction.member.nick} has submitted the idea \"#{idea}.\""
      )

    MusicBot.Ideas.create(%{
      idea: idea,
      author: interaction.member.nick,
      votes: 0,
      message_id: Integer.to_string(response.id),
      user_id: Integer.to_string(interaction.member.user_id)
    })

    Api.Message.react(interaction.channel_id, response.id, "%F0%9F%91%8D")
  end

  # List all idears
  def handle_event(
        {:INTERACTION_CREATE,
         %Nostrum.Struct.Interaction{
           data: %{name: "list"}
         } = interaction, _ws_state}
      ) do
    ideas =
      Ideas.get_all()
      |> Enum.map(fn idea ->
        String.pad_trailing(Integer.to_string(idea.votes), 5, " ") <>
          String.pad_trailing(idea.author, 20, " ") <> idea.idea
      end)
      |> Enum.join("\n")

    Api.Interaction.create_response(interaction, %{
      # ChannelMessageWithSource
      type: 4,
      data: %{
        content: "\n```" <> ideas <> "```"
      }
    })
  end

  def handle_event(
        {:INTERACTION_CREATE,
         %Nostrum.Struct.Interaction{
           data: %{name: "pick"}
         } = interaction, _ws_state}
      ) do
    idea = MusicBot.Vote.pick()

    Api.Interaction.create_response(interaction, %{
      type: 4,
      data: %{
        content: "The next theme is: \"" <> idea.idea <> "\" by *" <> idea.author <> "*"
      }
    })
  end

  def handle_event({:MESSAGE_REACTION_ADD, %MessageReactionAdd{} = reaction, _ws_state}) do
    MusicBot.Vote.reaction_add(reaction)
  end

  def handle_event({:MESSAGE_REACTION_REMOVE, %MessageReactionRemove{} = reaction, _ws_state}) do
    MusicBot.Vote.reaction_remove(reaction)
  end

  # Default event handler, if you don't include this, your consumer WILL crash if
  # you don't have a method definition for each event type.
  def handle_event({event_name, _, _}) do
    event_name |> IO.inspect()
    :noop
  end
end
