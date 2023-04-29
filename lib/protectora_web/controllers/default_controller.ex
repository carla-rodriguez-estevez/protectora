defmodule ProtectoraWeb.DefaultController do
  use ProtectoraWeb, :controller

  # Add router en router.ex

  def index(conn, _params) do
    text(conn, "The real deal API is Live")
  end
end
