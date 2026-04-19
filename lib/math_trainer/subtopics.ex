defmodule MathTrainer.Subtopics do
  @moduledoc """
  The Subtopics context.
  """

  import Ecto.Query, warn: false
  alias MathTrainer.Repo

  alias MathTrainer.Subtopics.Subtopic

  @doc """
  Returns the list of subtopics.

  ## Examples

      iex> list_subtopics()
      [%Subtopic{}, ...]

  """
  def list_subtopics do
    Repo.all(Subtopic)
  end

  @doc """
  Gets a single subtopic.

  Raises `Ecto.NoResultsError` if the Subtopic does not exist.

  ## Examples

      iex> get_subtopic!(123)
      %Subtopic{}

      iex> get_subtopic!(456)
      ** (Ecto.NoResultsError)

  """
  def get_subtopic!(id), do: Repo.get!(Subtopic, id)

  @doc """
  Creates a subtopic.

  ## Examples

      iex> create_subtopic(%{field: value})
      {:ok, %Subtopic{}}

      iex> create_subtopic(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_subtopic(attrs) do
    %Subtopic{}
    |> Subtopic.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a subtopic.

  ## Examples

      iex> update_subtopic(subtopic, %{field: new_value})
      {:ok, %Subtopic{}}

      iex> update_subtopic(subtopic, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_subtopic(%Subtopic{} = subtopic, attrs) do
    subtopic
    |> Subtopic.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a subtopic.

  ## Examples

      iex> delete_subtopic(subtopic)
      {:ok, %Subtopic{}}

      iex> delete_subtopic(subtopic)
      {:error, %Ecto.Changeset{}}

  """
  def delete_subtopic(%Subtopic{} = subtopic) do
    Repo.delete(subtopic)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking subtopic changes.

  ## Examples

      iex> change_subtopic(subtopic)
      %Ecto.Changeset{data: %Subtopic{}}

  """
  def change_subtopic(%Subtopic{} = subtopic, attrs \\ %{}) do
    Subtopic.changeset(subtopic, attrs)
  end

  def list_subtopics_by_topic(topic_id) do
    Subtopic
    |> where([s], s.topic_id == ^topic_id)
    |> order_by([s], s.order)
    |> Repo.all()
  end
end
