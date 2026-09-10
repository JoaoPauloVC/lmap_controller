defmodule LmapControllerWeb.ReportedStateController do
  use LmapControllerWeb, :controller

  alias LmapController.Agents

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
