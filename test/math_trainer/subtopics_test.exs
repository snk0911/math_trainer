defmodule MathTrainer.SubtopicsTest do
  use MathTrainer.DataCase

  alias MathTrainer.Subtopics

  describe "subtopics" do
    alias MathTrainer.Subtopics.Subtopic

    import MathTrainer.SubtopicsFixtures

    @invalid_attrs %{name: nil, order: nil}

    test "list_subtopics/0 returns all subtopics" do
      subtopic = subtopic_fixture()
      assert Subtopics.list_subtopics() == [subtopic]
    end

    test "get_subtopic!/1 returns the subtopic with given id" do
      subtopic = subtopic_fixture()
      assert Subtopics.get_subtopic!(subtopic.id) == subtopic
    end

    test "create_subtopic/1 with valid data creates a subtopic" do
      valid_attrs = %{name: "some name", order: 42}

      assert {:ok, %Subtopic{} = subtopic} = Subtopics.create_subtopic(valid_attrs)
      assert subtopic.name == "some name"
      assert subtopic.order == 42
    end

    test "create_subtopic/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Subtopics.create_subtopic(@invalid_attrs)
    end

    test "update_subtopic/2 with valid data updates the subtopic" do
      subtopic = subtopic_fixture()
      update_attrs = %{name: "some updated name", order: 43}

      assert {:ok, %Subtopic{} = subtopic} = Subtopics.update_subtopic(subtopic, update_attrs)
      assert subtopic.name == "some updated name"
      assert subtopic.order == 43
    end

    test "update_subtopic/2 with invalid data returns error changeset" do
      subtopic = subtopic_fixture()
      assert {:error, %Ecto.Changeset{}} = Subtopics.update_subtopic(subtopic, @invalid_attrs)
      assert subtopic == Subtopics.get_subtopic!(subtopic.id)
    end

    test "delete_subtopic/1 deletes the subtopic" do
      subtopic = subtopic_fixture()
      assert {:ok, %Subtopic{}} = Subtopics.delete_subtopic(subtopic)
      assert_raise Ecto.NoResultsError, fn -> Subtopics.get_subtopic!(subtopic.id) end
    end

    test "change_subtopic/1 returns a subtopic changeset" do
      subtopic = subtopic_fixture()
      assert %Ecto.Changeset{} = Subtopics.change_subtopic(subtopic)
    end
  end
end
