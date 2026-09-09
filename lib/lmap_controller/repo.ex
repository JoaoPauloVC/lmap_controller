defmodule LmapController.Repo do
  use Ecto.Repo,
    otp_app: :lmap_controller,
    adapter: Ecto.Adapters.Postgres
end
