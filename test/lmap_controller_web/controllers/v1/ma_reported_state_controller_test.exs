defmodule LmapControllerWeb.V1.MAReportedStateControllerTest do
  use LmapControllerWeb.ConnCase, async: true

  alias LmapController.Repo
  alias LmapController.Agents.MeasurementAgent

  test "accepts the reported state from a measurement agent and returns 204", %{conn: conn} do
    agent_id = "test-ma"

    reported_state = %{
      "status" => "reported"
    }

    conn =
      put(
        conn,
        ~p"/v1/agents/#{agent_id}/reported-state",
        reported_state
      )

    assert response(conn, 204)

    measurement_agent =
      Repo.get_by(MeasurementAgent, agent_id: agent_id)

    assert %MeasurementAgent{} = measurement_agent
    assert measurement_agent.agent_id == agent_id
    assert measurement_agent.reported_state == reported_state
    assert measurement_agent.last_seen_at != nil
  end
end
