defmodule MathTrainer.TopicsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `MathTrainer.Topics` context.
  """

  @doc """
  Generate a topic.
  """
  def topic_fixture(attrs \\ %{}) do
    {:ok, topic} =
      attrs
      |> Enum.into(%{
        name: "some name",
        order: 42
      })
      |> MathTrainer.Topics.create_topic()

    topic
  end
end
