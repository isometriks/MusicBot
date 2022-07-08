defmodule MusicBot.Repo.Migrations.CreateIdeas do
  use Ecto.Migration

  def change do
    create table(:ideas) do
      add :author, :string
      add :idea, :string
      add :votes, :integer
    end
  end
end
