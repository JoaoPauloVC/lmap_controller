defmodule LmapController.Repo.Migrations.AddDesiredConfigToAgents do
  use Ecto.Migration

  def change do
    alter table(:agents) do
      add :desired_config, :map
    end
  end
end
