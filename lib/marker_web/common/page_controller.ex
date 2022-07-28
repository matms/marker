defmodule MarkerWeb.PageController do
  use MarkerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
