defmodule MusicBot.Ideas do
  alias MusicBot.Repo
  alias MusicBot.Schemas.Idea

  def change(%Idea{} = idea, attrs \\ %{}) do
    Idea.changeset(idea, attrs)
  end

  def create(attrs \\ %{}) do
    %Idea{}
    |> change(attrs)
    |> Repo.insert()
  end

  def get_by_id(idea_id) do
    Repo.get(Idea, idea_id)
  end

  def get_by_message_id(message_id) do
    Repo.get_by(Idea, message_id: message_id)
  end

  def get_all() do
    import Ecto.Query

    query =
      from(i in Idea,
        where: i.active == true,
        select: i,
        order_by: [desc: :votes]
      )

    Repo.all(query)
  end

  def update(idea) do
    idea
    |> Repo.update()
  end
end
