defmodule MusicBot.BotConsumer do
  use Nostrum.Consumer

  alias Nostrum.Api

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

  # def handle_event(other) do
  #  other |> IO.inspect
  # end

  # Default event handler, if you don't include this, your consumer WILL crash if
  # you don't have a method definition for each event type.
  def handle_event(_event) do
    :noop
  end
end
