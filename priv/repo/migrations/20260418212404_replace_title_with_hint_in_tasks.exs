defmodule MathTrainer.Repo.Migrations.ReplaceTitleWithHintInTasks do
  use Ecto.Migration

  def change do
    alter table(:tasks) do
      remove :title
      add :hint, :text
    end
  end
end