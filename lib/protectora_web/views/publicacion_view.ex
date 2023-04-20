defmodule ProtectoraWeb.PublicacionView do
  use ProtectoraWeb, :view

  require Logger
  alias ProtectoraWeb.{PublicacionView, ImaxePublicacionView}

  def render("index.json", %{publicacion: publicacion}) do
    %{data: render_many(publicacion, PublicacionView, "publicacion.json")}
  end

  def render("created.json", %{publicacion: publicacion}) do
    %{data: render_one(publicacion, PublicacionView, "publicacion.json")}
  end


  def render("show.json", %{publicacion: publicacion}) do
    %{data: render_one(publicacion, PublicacionView, "publicacion_completa.json")}
  end

  def render("publicacion.json", %{publicacion: publicacion}) do
    %{
      id: publicacion.id,
      titulo: publicacion.titulo,
      contido: publicacion.contido,
      publicacionDate: publicacion.inserted_at
    }
  end

  def render("publicacion_completa.json", %{publicacion: publicacion}) do
    %{
        id: publicacion.id,
        titulo: publicacion.titulo,
        contido: publicacion.contido,
        publicacionDate: publicacion.inserted_at,
        imaxes: render_many(publicacion.imaxe_publicacion, ImaxePublicacionView, "show.json")
    }
  end
end
