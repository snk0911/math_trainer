defmodule MathTrainer.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :problem, :string
    field :hint, :string
    field :solution, :string
    field :order, :integer
    field :subtopic_id, :id
    timestamps(type: :utc_datetime)
  end

  def changeset(task, attrs) do
    task
    |> cast(attrs, [:problem, :hint, :solution, :order, :subtopic_id])
    |> validate_required([:problem, :solution, :order, :subtopic_id])
  end
end
