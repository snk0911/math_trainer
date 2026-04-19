defmodule MathTrainer.Subtopics.Subtopic do
  use Ecto.Schema
  import Ecto.Changeset

  schema "subtopics" do
    field :name, :string
    field :order, :integer
    field :topic_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(subtopic, attrs) do
    subtopic
    |> cast(attrs, [:name, :order, :topic_id])
    |> validate_required([:name, :order, :topic_id])
  end
end
