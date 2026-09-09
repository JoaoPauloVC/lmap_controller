defmodule LmapControllerWeb.PageController do
  use LmapControllerWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
