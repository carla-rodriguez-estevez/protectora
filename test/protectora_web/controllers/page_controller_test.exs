defmodule ProtectoraWeb.PageControllerTest do
  use ProtectoraWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Protectora"
  end
end
