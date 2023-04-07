defmodule ProtectoraWeb.RexistroView do
  use ProtectoraWeb, :view
  alias ProtectoraWeb.RexistroView

  def render("index.json", %{rexistro: rexistro}) do
    %{data: render_many(rexistro, RexistroView, "rexistro.json")}
  end

  def render("show.json", %{rexistro: rexistro}) do
    %{data: render_one(rexistro, RexistroView, "rexistro.json")}
  end

  def render("rexistro.json", %{rexistro: rexistro}) do
    %{
      id: rexistro.id,
      titulo: rexistro.titulo,
      descricion: rexistro.descricion,
      prezo: rexistro.prezo
    }
  end
end
