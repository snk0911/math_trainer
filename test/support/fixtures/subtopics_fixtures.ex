defmodule MathTrainer.SubtopicsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `MathTrainer.Subtopics` context.
  """

  @doc """
  Generate a subtopic.
  """
  def subtopic_fixture(attrs \\ %{}) do
    {:ok, subtopic} =
      attrs
      |> Enum.into(%{
        name: "some name",
        order: 42
      })
      |> MathTrainer.Subtopics.create_subtopic()

    subtopic
  end
end
