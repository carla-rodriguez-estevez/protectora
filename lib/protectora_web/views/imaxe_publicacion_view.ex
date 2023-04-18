defmodule ProtectoraWeb.ImaxePublicacionView do
  use ProtectoraWeb, :view
  alias ProtectoraWeb.ImaxePublicacionView

  def render("index.json", %{imaxe_publicacion: imaxe_publicacion}) do
    %{data: render_many(imaxe_publicacion, ImaxePublicacionView, "imaxe_publicacion.json")}
  end

  def render("show.json", %{imaxe_publicacion: imaxe_publicacion}) do
    %{data: render_one(imaxe_publicacion, ImaxePublicacionView, "imaxe_publicacion.json")}
  end

  def render("imaxe_publicacion.json", %{imaxe_publicacion: imaxe_publicacion}) do
    %{
      id: imaxe_publicacion.id,
      path_imaxe: imaxe_publicacion.path_imaxe
    }
  end
end
