defmodule MathTrainer.TasksTest do
  use MathTrainer.DataCase

  alias MathTrainer.Tasks

  describe "tasks" do
    alias MathTrainer.Tasks.Task

    import MathTrainer.TasksFixtures

    @invalid_attrs %{title: nil, problem: nil, solution: nil, order: nil}

    test "list_tasks/0 returns all tasks" do
      task = task_fixture()
      assert Tasks.list_tasks() == [task]
    end

    test "get_task!/1 returns the task with given id" do
      task = task_fixture()
      assert Tasks.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      valid_attrs = %{title: "some title", problem: "some problem", solution: "some solution", order: 42}

      assert {:ok, %Task{} = task} = Tasks.create_task(valid_attrs)
      assert task.title == "some title"
      assert task.problem == "some problem"
      assert task.solution == "some solution"
      assert task.order == 42
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tasks.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      task = task_fixture()
      update_attrs = %{title: "some updated title", problem: "some updated problem", solution: "some updated solution", order: 43}

      assert {:ok, %Task{} = task} = Tasks.update_task(task, update_attrs)
      assert task.title == "some updated title"
      assert task.problem == "some updated problem"
      assert task.solution == "some updated solution"
      assert task.order == 43
    end

    test "update_task/2 with invalid data returns error changeset" do
      task = task_fixture()
      assert {:error, %Ecto.Changeset{}} = Tasks.update_task(task, @invalid_attrs)
      assert task == Tasks.get_task!(task.id)
    end

    test "delete_task/1 deletes the task" do
      task = task_fixture()
      assert {:ok, %Task{}} = Tasks.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> Tasks.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      task = task_fixture()
      assert %Ecto.Changeset{} = Tasks.change_task(task)
    end
  end
end
