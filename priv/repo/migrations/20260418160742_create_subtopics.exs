defmodule MathTrainer.Repo.Migrations.CreateSubtopics do
  use Ecto.Migration

  def change do
    create table(:subtopics) do
      add :name, :string
      add :order, :integer
      add :topic_id, references(:topics, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:subtopics, [:topic_id])
  end
end
