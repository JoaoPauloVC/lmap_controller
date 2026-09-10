defmodule LmapControllerWeb.V1.MAReportedStateController do
  use LmapControllerWeb, :controller
  alias LmapController.Agents

  # Measurement Agent (MA) reports its current state to the LMAP Controller
  # The LMAP Controller stores the reported state in the database
  def update(conn, %{"agent_id" => agent_id}) do
    reported_state = conn.body_params

    case Agents.update_reported_state(agent_id, reported_state) do
      # 204 -> :no_content, meaning the request was successful but there's no content to send back
      {:ok, _measurement_agent} ->
        send_resp(conn, :no_content, "")

      # 422 -> :unprocessable_entity, meaning the request was well-formed but couldn't be processed due to semantic errors
      {:error, _changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: "could not store reported state"})
    end
  end
end
