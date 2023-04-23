defmodule ProtectoraWeb.ImaxeAnimalView do
  use ProtectoraWeb, :view
  alias ProtectoraWeb.ImaxeAnimalView

  def upload_directory do
    Application.get_env(:protectora, :publicacions_directory)
  end

  def render("index.json", %{imaxe_animal: imaxe_animal}) do
    %{data: render_many(imaxe_animal, ImaxeAnimalView, "imaxe_animal.json")}
  end

  def render("show.json", %{imaxe_animal: imaxe_animal}) do
    %{data: render_one(imaxe_animal, ImaxeAnimalView, "imaxe_animal.json")}
  end

  def render("imaxe_animal.json", %{imaxe_animal: imaxe_animal}) do
    file = File.read!(String.replace(upload_directory(), "/publicacions", "") <> imaxe_animal.path_imaxe)
    file_base_64 = "data:image/gif;base64," <> Base.encode64(file)

    %{
      id: imaxe_animal.id,
      imaxe64: file_base_64
    }
  end
end
