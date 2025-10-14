defmodule MusicBot.Vote do
  @thumbs_up 128_077

  alias MusicBot.Ideas
  alias MusicBot.Schemas.Idea

  alias Nostrum.Struct.Event.MessageReactionAdd
  alias Nostrum.Struct.Event.MessageReactionRemove

  def reaction_add(%MessageReactionAdd{} = reaction) do
    idea = MusicBot.Ideas.get_by_message_id(Integer.to_string(reaction.message_id))

    if can_vote(idea, reaction) do
      update_votes(idea, 1)
    end
  end

  def reaction_remove(%MessageReactionRemove{} = reaction) do
    idea = MusicBot.Ideas.get_by_message_id(Integer.to_string(reaction.message_id))

    if can_vote(idea, reaction) do
      update_votes(idea, -1)
    end
  end

  def pick() do
    Ideas.get_all()
    |> fill_list
    |> List.flatten()
    |> Enum.random()
  end

  defp can_vote(%Idea{} = idea, reaction) do
    [code] = String.to_charlist(reaction.emoji.name)

    code == @thumbs_up &&
      Application.get_env(:musicbot, :bot_id) !== reaction.user_id &&
      Integer.to_string(reaction.user_id) !== idea.user_id
  end

  defp can_vote(nil, _reaction) do
    false
  end

  defp fill_list(ideas) do
    ideas
    |> Enum.map(fn %Idea{} = idea ->
      [1..idea.votes]
      |> Enum.map(fn _ -> idea end)
    end)
  end

  defp update_votes(%Idea{} = idea, difference) do
    Ideas.change(idea, %{
      votes: idea.votes + difference
    })
    |> Ideas.update()
  end
end
