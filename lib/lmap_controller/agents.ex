defmodule LmapController.Agents do
  alias LmapController.Repo
  alias LmapController.Agents.MeasurementAgent

  # Create or update the reported state of a Measurement Agent (MA) in the database
  def update_reported_state(agent_id, reported_state) do
    attrs = %{
      agent_id: agent_id,
      reported_state: reported_state,
      last_seen_at: DateTime.utc_now()
    }

    case Repo.get_by(MeasurementAgent, agent_id: agent_id) do
      nil ->
        %MeasurementAgent{}
        |> MeasurementAgent.changeset(attrs)
        |> Repo.insert()

      measurement_agent ->
        measurement_agent
        |> MeasurementAgent.changeset(attrs)
        |> Repo.update()
    end
  end
end
