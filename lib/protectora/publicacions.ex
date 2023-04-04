defmodule Protectora.Publicacions do
  require Logger

  @moduledoc """
  The Publicacions context.
  """

  import Ecto.Query, warn: false
  alias Protectora.Repo

  alias Protectora.Publicacions.Publicacion

  @doc """
  Returns the list of publicacion.

  ## Examples

      iex> list_publicacion()
      [%Publicacion{}, ...]

  """
  def list_publicacion do
    Repo.all(Publicacion)
  end

  @doc """
  Gets a single publicacion.

  Raises `Ecto.NoResultsError` if the Publicacion does not exist.

  ## Examples

      iex> get_publicacion!(123)
      %Publicacion{}

      iex> get_publicacion!(456)
      ** (Ecto.NoResultsError)

  """
  def get_publicacion!(id), do: Repo.get!(Publicacion, id)

  @doc """
  Creates a publicacion.

  ## Examples

      iex> create_publicacion(%{field: value})
      {:ok, %Publicacion{}}

      iex> create_publicacion(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_publicacion(attrs \\ %{}) do
    %Publicacion{}
    |> Publicacion.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:post_created)
  end

  @doc """
  Updates a publicacion.

  ## Examples

      iex> update_publicacion(publicacion, %{field: new_value})
      {:ok, %Publicacion{}}

      iex> update_publicacion(publicacion, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_publicacion(%Publicacion{} = publicacion, attrs) do
    publicacion
    |> Publicacion.changeset(attrs)
    |> Repo.update()
    |> broadcast(:post_updated)
  end

  @doc """
  Deletes a publicacion.

  ## Examples

      iex> delete_publicacion(publicacion)
      {:ok, %Publicacion{}}

      iex> delete_publicacion(publicacion)
      {:error, %Ecto.Changeset{}}

  """
  def delete_publicacion(%Publicacion{} = publicacion) do
    publicacion
    |> Repo.delete()
    |> broadcast(:post_deleted)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking publicacion changes.

  ## Examples

      iex> change_publicacion(publicacion)
      %Ecto.Changeset{data: %Publicacion{}}

  """
  def change_publicacion(%Publicacion{} = publicacion, attrs \\ %{}) do
    Publicacion.changeset(publicacion, attrs)
  end

  def subscribe do
    Phoenix.PubSub.subscribe(Protectora.PubSub, "posts")
  end

  defp broadcast({:error, _reason} = error, _event), do: error

  defp broadcast({:ok, post}, event) do
    Phoenix.PubSub.broadcast(Protectora.PubSub, "posts", {event, post})
    {:ok, post}
  end
end
