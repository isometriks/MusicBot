defmodule MusicBot.Repo.Migrations.AddActiveToIdeas do
  use Ecto.Migration

  def change do
    alter table(:ideas) do
      add :active, :boolean, default: true
    end
  end
end
