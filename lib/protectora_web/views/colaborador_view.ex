defmodule ProtectoraWeb.ColaboradorView do
  use ProtectoraWeb, :view
  alias ProtectoraWeb.ColaboradorView

  def render("index.json", %{colaborador: colaborador}) do
    %{data: render_many(colaborador, ColaboradorView, "colaborador.json")}
  end

  def render("show.json", %{colaborador: colaborador}) do
    %{data: render_one(colaborador, ColaboradorView, "colaborador.json")}
  end

  def render("colaborador.json", %{colaborador: colaborador}) do
    %{
      id: colaborador.id,
      nome: colaborador.nome,
      apelidos: colaborador.apelidos,
      dataNacemento: colaborador.dataNacemento,
      direccion: colaborador.direccion,
      codigoPostal: colaborador.codigoPostal,
      localidade: colaborador.localidade,
      email: colaborador.email,
      numeroConta: colaborador.numeroConta,
      cantidadeAporte: colaborador.cantidadeAporte,
      perioricidade: colaborador.perioricidade
    }
  end
end
