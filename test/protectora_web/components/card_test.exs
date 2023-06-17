defmodule ProtectoraWeb.Components.CardTest do
  use ProtectoraWeb.ConnCase

  import Phoenix.LiveViewTest

  describe "AnimalCard component" do
    test "renderiza correctamente los animales", %{conn: conn} do
      # Simula a montaxe do
      html = render_component(ProtectoraWeb.Components.AnimalCardList, animais: [])

      assert html =~ "class=\"content\""
      assert html =~ "class=\"container mx-auto\""
      assert html =~ "class=\"grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mx-12 my-12\""
    end
  end
end
