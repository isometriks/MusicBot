defmodule MusicBot.Choose do
  @check_mark 9_989

  alias MusicBot.Ideas
  alias MusicBot.Picks
  alias MusicBot.Schemas.Pick

  alias Nostrum.Api
  alias Nostrum.Struct.Event.MessageReactionAdd
  alias Nostrum.Struct.Event.MessageReactionRemove

  def store_pick(message_id, idea, interaction) do
    Picks.create(%{
      idea_id: idea.id,
      user_id: Integer.to_string(interaction.user.id),
      message_id: Integer.to_string(message_id)
    })

    Api.Message.react(interaction.channel_id, message_id, "%E2%9C%85")
  end

  def reaction_add(%MessageReactionAdd{} = reaction) do
    pick = Picks.get_by_message_id(Integer.to_string(reaction.message_id))

    if can_vote(pick, reaction) do
      update_active(pick, false)
    end
  end

  def reaction_remove(%MessageReactionRemove{} = reaction) do
    pick = Picks.get_by_message_id(Integer.to_string(reaction.message_id))

    if can_vote(pick, reaction) do
      update_active(pick, true)
    end
  end

  defp can_vote(%Pick{} = pick, reaction) do
    # For now, let anyone mark the idea as picked as long as it's the check mark too
    [code] = String.to_charlist(reaction.emoji.name)

    code == @check_mark &&
      Application.get_env(:musicbot, :bot_id) !== reaction.user_id &&
      Integer.to_string(reaction.user_id) == pick.user_id
  end

  defp can_vote(nil, _reaction) do
    false
  end

  defp update_active(%Pick{} = pick, state) do
    Ideas.get_by_id(pick.idea_id)
    |> Ideas.change(%{ active: state })
    |> Ideas.update()
  end
end
