defmodule LmapController.Repo.Migrations.CreateAgents do
  use Ecto.Migration

  def change do
    create table(:agents) do
      add :agent_id, :string, null: false
      add :reported_state, :map
      add :last_seen_at, :utc_datetime_usec

      timestamps(type: :utc_datetime_usec)
    end

    create unique_index(:agents, [:agent_id])
  end
end
