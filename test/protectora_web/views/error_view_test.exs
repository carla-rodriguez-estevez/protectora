defmodule ProtectoraWeb.ErrorViewTest do
  use ProtectoraWeb.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 404.html" do
    assert render_to_string(ProtectoraWeb.ErrorView, "404.html", []) ==
             "Not Found"
  end

  test "renders 500.html" do
    assert render_to_string(ProtectoraWeb.ErrorView, "500.html", []) ==
             "Internal Server Error"
  end

  test "renders 401 error" do
    assert_raise ProtectoraWeb.Auth.ErrorResponse.Unauthorized, fn ->
      raise ProtectoraWeb.Auth.ErrorResponse.Unauthorized
    end
  end

  test "renders 403 error" do
    assert_raise ProtectoraWeb.Auth.ErrorResponse.Forbidden, fn ->
      raise ProtectoraWeb.Auth.ErrorResponse.Forbidden
    end
  end

  test "renders 404 error" do
    assert_raise ProtectoraWeb.Auth.ErrorResponse.NotFound, fn ->
      raise ProtectoraWeb.Auth.ErrorResponse.NotFound
    end
  end
end
