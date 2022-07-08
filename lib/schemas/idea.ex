defmodule MusicBot.Schemas.Idea do
  use Ecto.Schema
  import Ecto.Changeset

  schema "ideas" do
    field(:author, :string)
    field(:idea, :string)
    field(:votes, :integer)
  end

  def changeset(idea, attrs) do
    idea
    |> cast(attrs, [:author, :idea, :votes])
    |> validate_required([:author, :idea, :votes])
  end
end
