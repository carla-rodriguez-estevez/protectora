defmodule ProtectoraWeb.VoluntarioView do
  use ProtectoraWeb, :view
  alias ProtectoraWeb.VoluntarioView

  def render("index.json", %{voluntario: voluntario}) do
    %{data: render_many(voluntario, VoluntarioView, "voluntario.json")}
  end

  def render("show.json", %{voluntario: voluntario}) do
    %{data: render_one(voluntario, VoluntarioView, "voluntario.json")}
  end

  def render("voluntario.json", %{voluntario: voluntario}) do
    %{
      id: voluntario.id,
      nome: voluntario.nome,
      contrasinal: voluntario.contrasinal,
      email: voluntario.email
    }
  end

  def render("voluntario_token.json", %{voluntario: voluntario, token: token}) do
    %{
      id: voluntario.id,
      email: voluntario.email,
      token: token
    }
  end
end
