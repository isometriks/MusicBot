defmodule MusicBot.Picks do
  alias MusicBot.Repo
  alias MusicBot.Schemas.Pick

  def change(%Pick{} = pick, attrs \\ %{}) do
    Pick.changeset(pick, attrs)
  end

  def create(attrs \\ %{}) do
    %Pick{}
    |> change(attrs)
    |> Repo.insert()
  end

  def get_by_message_id(message_id) do
    Repo.get_by(Pick, message_id: message_id)
  end

  def get_by_idea_id(idea_id) do
    Repo.get_by(Pick, idea_id: idea_id)
  end

  def get_by_user_id(user_id) do
    import Ecto.Query
    
    query = 
      from(p in Pick,
        where: p.user_id == ^user_id,
        select: p,
        order_by: [desc: :inserted_at]
      )
    
    Repo.all(query)
  end

  def get_all() do
    import Ecto.Query
    
    query =
      from(p in Pick,
        preload: [:idea],
        select: p,
        order_by: [desc: :inserted_at]
      )

    Repo.all(query)
  end
end
