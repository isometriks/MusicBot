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
end
