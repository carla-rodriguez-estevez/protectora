defmodule ProtectoraWeb.PageController do
  use ProtectoraWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
