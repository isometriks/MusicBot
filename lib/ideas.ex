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

  def get_by_message_id(message_id) do
    Repo.get_by(Idea, message_id: message_id)
  end

  def update(idea) do
    idea
    |> Repo.update()
  end
end
