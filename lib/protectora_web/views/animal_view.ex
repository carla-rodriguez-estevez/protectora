defmodule ProtectoraWeb.AnimalView do
  use ProtectoraWeb, :view
  alias ProtectoraWeb.AnimalView

  def render("index.json", %{animal: animal}) do
    %{data: render_many(animal, AnimalView, "animal.json")}
  end

  def render("show.json", %{animal: animal}) do
    %{data: render_one(animal, AnimalView, "animal.json")}
  end

  def render("animal.json", %{animal: animal}) do
    %{
      id: animal.id,
      nome: animal.nome,
      tipo: animal.tipo,
      peso: animal.peso,
      madurez: animal.madurez,
      tamano: animal.tamano,
      raza: animal.raza,
      idade: animal.idade,
      descricion: animal.descricion,
      eUrxente: animal.eUrxente,
      eEspecial: animal.eEspecial
    }
  end
end
