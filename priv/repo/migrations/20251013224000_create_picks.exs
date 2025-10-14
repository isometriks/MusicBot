defmodule MusicBot.Repo.Migrations.CreatePicks do
  use Ecto.Migration

  def change do
    create table(:picks) do
      add :idea_id, references(:ideas, on_delete: :delete_all), null: false
      add :user_id, :string, null: false
      add :message_id, :string, null: false
      
      timestamps()
    end

    create index(:picks, [:idea_id])
    create index(:picks, [:user_id])
    create index(:picks, [:message_id])
  end
end
