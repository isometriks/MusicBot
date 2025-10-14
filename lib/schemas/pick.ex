defmodule MusicBot.Schemas.Pick do
  use Ecto.Schema
  import Ecto.Changeset

  alias MusicBot.Schemas.Idea

  schema "picks" do
    belongs_to(:idea, Idea)
    field(:user_id, :string)
    field(:message_id, :string)

    timestamps()
  end

  def changeset(pick, attrs) do
    pick
    |> cast(attrs, [:idea_id, :user_id, :message_id])
    |> validate_required([:idea_id, :user_id, :message_id])
    |> foreign_key_constraint(:idea_id)
  end
end
