defmodule ProtectoraWeb.PadrinamentoView do
  use ProtectoraWeb, :view
  alias ProtectoraWeb.PadrinamentoView

  def render("index.json", %{padrinamento: padrinamento}) do
    %{data: render_many(padrinamento, PadrinamentoView, "padrinamento.json")}
  end

  def render("show.json", %{padrinamento: padrinamento}) do
    %{data: render_one(padrinamento, PadrinamentoView, "padrinamento.json")}
  end

  def render("padrinamento.json", %{padrinamento: padrinamento}) do
    %{
      id: padrinamento.id,
      cantidade_aporte: padrinamento.cantidade_aporte,
      perioricidade: padrinamento.perioricidade
    }
  end
end
