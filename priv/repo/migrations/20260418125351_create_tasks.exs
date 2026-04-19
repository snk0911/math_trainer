defmodule MathTrainer.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :title, :string
      add :problem, :text
      add :solution, :text
      add :order, :integer
      add :topic_id, references(:topics, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:tasks, [:topic_id])
  end
end
