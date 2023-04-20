defmodule ProtectoraWeb.ImaxePublicacionView do
  use ProtectoraWeb, :view
  alias ProtectoraWeb.ImaxePublicacionView

  def upload_directory do
    Application.get_env(:protectora, :publicacions_directory)
  end

  def render("index.json", %{imaxe_publicacion: imaxe_publicacion}) do
    %{data: render_many(imaxe_publicacion, ImaxePublicacionView, "imaxe_publicacion.json")}
  end

  def render("show.json", %{imaxe_publicacion: imaxe_publicacion}) do
    %{data: render_one(imaxe_publicacion, ImaxePublicacionView, "imaxe_publicacion.json")}
  end

  def render("imaxe_publicacion.json", %{imaxe_publicacion: imaxe_publicacion}) do

    file = File.read!(String.replace(upload_directory(), "/publicacions", "") <> imaxe_publicacion.path_imaxe)
    file_base_64 = "data:image/gif;base64," <> Base.encode64(file)

    %{
      id: imaxe_publicacion.id,
      imaxe64: file_base_64
    }
  end
end
