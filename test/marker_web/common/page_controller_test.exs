defmodule MarkerWeb.PageControllerTest do
  @moduledoc false

  use MarkerWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Marker"
  end
end
