defmodule ProtectoraWeb.PublicacionView do
  use ProtectoraWeb, :view
  alias ProtectoraWeb.PublicacionView

  def render("index.json", %{publicacion: publicacion}) do
    %{data: render_many(publicacion, PublicacionView, "publicacion.json")}
  end

  def render("show.json", %{publicacion: publicacion}) do
    %{data: render_one(publicacion, PublicacionView, "publicacion.json")}
  end

  def render("publicacion.json", %{publicacion: publicacion}) do
    %{
      id: publicacion.id,
      titulo: publicacion.titulo,
      contido: publicacion.contido,
      publicacionDate: publicacion.inserted_at
    }
  end
end
