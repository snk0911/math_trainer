defmodule MathTrainer.TasksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `MathTrainer.Tasks` context.
  """

  @doc """
  Generate a task.
  """
  def task_fixture(attrs \\ %{}) do
    {:ok, task} =
      attrs
      |> Enum.into(%{
        order: 42,
        problem: "some problem",
        solution: "some solution",
        title: "some title"
      })
      |> MathTrainer.Tasks.create_task()

    task
  end
end
