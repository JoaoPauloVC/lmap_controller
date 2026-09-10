defmodule LmapControllerWeb.MADesiredConfigController do
  use LmapControllerWeb, :controller
  alias LmapController.Agents

  # The orchestrator (in this moment, being simulated) sets the desired configuration for a Measurement Agent (MA).
  def update(conn, %{"agent_id" => agent_id}) do
    desired_config = conn.body_params

    case Agents.set_desired_config(agent_id, desired_config) do
      {:ok, _measurement_agent} ->
        send_resp(conn, :no_content, "")

      {:error, :agent_not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "measurement agent not found"})

      {:error, _changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: "could not store desired config"})
    end
  end
end
