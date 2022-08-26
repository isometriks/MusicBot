defmodule MusicBot.Schemas.Idea do
  use Ecto.Schema
  import Ecto.Changeset

  schema "ideas" do
    field(:author, :string)
    field(:idea, :string)
    field(:votes, :integer)
    field(:message_id, :string)
    field(:user_id, :string)
  end

  def changeset(idea, attrs) do
    idea
    |> cast(attrs, [:author, :idea, :votes, :message_id, :user_id])
    |> validate_required([:author, :idea, :votes, :message_id, :user_id])
  end
end
