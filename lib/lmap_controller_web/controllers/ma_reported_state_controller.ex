defmodule LmapControllerWeb.MAReportedStateController do
  use LmapControllerWeb, :controller
  alias LmapController.Agents

  # Measurement Agent (MA) reports its current state to the LMAP Controller
  # The LMAP Controller stores the reported state in the database
  def update(conn, %{"agent_id" => agent_id}) do
    reported_state = conn.body_params

    case Agents.update_reported_state(agent_id, reported_state) do
      {:ok, _measurement_agent} ->
        send_resp(conn, :no_content, "")

      {:error, _changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: "could not store reported state"})
    end
  end
end
