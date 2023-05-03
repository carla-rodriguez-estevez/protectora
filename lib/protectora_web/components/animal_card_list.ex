defmodule ProtectoraWeb.Components.AnimalCardList do
  @moduledoc """
  A sample component generated by `mix surface.init`.
  """
  use Surface.LiveComponent
  require Logger

  def render(assigns) do
    animais = Protectora.Animais.list_animal_paginated()

    ~F"""
    <style>
      .content {
      @apply mb-2;
      }
    </style>

    <div class="content" id="animals list">
      <div class="container mx-auto">
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mx-12 my-12">
          {#for animal <- animais}
            <div class="flex justify-center">
              <ProtectoraWeb.Components.Card max_width="md" rounded>
                <:name>
                  {animal.nome}
                </:name>
                <:tipo>
                  {animal.tipo}
                </:tipo>
                <:tamano>
                  {animal.tamano}
                </:tamano>
                <:imaxe>
                  {#if length(animal.imaxe_animal) > 0}
                    <img src={Enum.at(animal.imaxe_animal, 0).path_imaxe}>
                  {#else}
                    <div class="" />
                  {/if}
                </:imaxe>
                <:link>
                  <a href={"/animal/" <> animal.id}>Obter máis información</a>
                </:link>
              </ProtectoraWeb.Components.Card>
            </div>
          {/for}
        </div>
      </div>
    </div>
    """
  end
end
