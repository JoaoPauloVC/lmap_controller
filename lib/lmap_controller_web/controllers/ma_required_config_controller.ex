defmodule LmapControllerWeb.MARequiredConfigController do
  use LmapControllerWeb, :controller

  # Measurement Agent (MA) requests the desired schedule from the LMAP Controller
  # The LMAP Controller responds with the desired schedule in JSON format
  def show(conn, %{"agent_id" => _agent_id}) do
    path =
      Application.app_dir(
        :lmap_controller,
        "priv/data/desired-schedule.json"
      )

    case File.read(path) do
      {:ok, schedule} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, schedule)

      {:error, _reason} ->
        conn
        |> put_status(:internal_server_error)
        |> json(%{error: "desired schedule unavailable"})
    end
  end
end
