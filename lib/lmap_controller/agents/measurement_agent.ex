defmodule LmapController.Agents.MeasurementAgent do
  use Ecto.Schema
  import Ecto.Changeset

  schema "agents" do
    field :agent_id, :string
    field :reported_state, :map
    field :last_seen_at, :utc_datetime_usec
    field :desired_config, :map

    # Add fields inserted_at and updated_at for timestamps
    timestamps(type: :utc_datetime_usec)
  end

  def changeset(measurement_agent, attrs) do
    measurement_agent
    |> cast(attrs, [:agent_id, :reported_state, :last_seen_at, :desired_config])
    # :desired_config is optional (it's possible that the system doesn't have a (new) desired config), so we don't include it in the required fields
    |> validate_required([:agent_id, :reported_state, :last_seen_at])
    |> unique_constraint(:agent_id)
  end
end
