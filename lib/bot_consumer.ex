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

    # msg |> IO.inspect()

    cond do
      String.contains?(message, "ryan") ->
        Api.create_message(msg.channel_id, "Oh that guy? He sucks.")

      String.contains?(message, "craig") ->
        Api.create_message(msg.channel_id, "You mean Greg?")

      true ->
        :ignore
    end
  end

  def handle_event({:READY, %Nostrum.Struct.Event.Ready{} = event, _ws_state}) do
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
    Api.create_interaction_response(interaction, %{
      # ChannelMessageWithSource
      type: 4,
      data: %{
        content: "Idea added: " <> idea
      }
    })
  end

  # Default event handler, if you don't include this, your consumer WILL crash if
  # you don't have a method definition for each event type.
  def handle_event({event_name, _, _}) do
    event_name |> IO.inspect()
    :noop
  end
end
