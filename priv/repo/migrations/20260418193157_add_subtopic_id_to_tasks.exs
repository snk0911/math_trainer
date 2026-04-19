defmodule MathTrainer.Repo.Migrations.AddSubtopicIdToTasks do
  use Ecto.Migration

  def change do
    alter table(:tasks) do
      add :subtopic_id, references(:subtopics, on_delete: :nothing)
    end
  end
end