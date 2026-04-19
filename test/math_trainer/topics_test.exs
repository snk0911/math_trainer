defmodule MathTrainer.TopicsTest do
  use MathTrainer.DataCase

  alias MathTrainer.Topics

  describe "topics" do
    alias MathTrainer.Topics.Topic

    import MathTrainer.TopicsFixtures

    @invalid_attrs %{name: nil, order: nil}

    test "list_topics/0 returns all topics" do
      topic = topic_fixture()
      assert Topics.list_topics() == [topic]
    end

    test "get_topic!/1 returns the topic with given id" do
      topic = topic_fixture()
      assert Topics.get_topic!(topic.id) == topic
    end

    test "create_topic/1 with valid data creates a topic" do
      valid_attrs = %{name: "some name", order: 42}

      assert {:ok, %Topic{} = topic} = Topics.create_topic(valid_attrs)
      assert topic.name == "some name"
      assert topic.order == 42
    end

    test "create_topic/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Topics.create_topic(@invalid_attrs)
    end

    test "update_topic/2 with valid data updates the topic" do
      topic = topic_fixture()
      update_attrs = %{name: "some updated name", order: 43}

      assert {:ok, %Topic{} = topic} = Topics.update_topic(topic, update_attrs)
      assert topic.name == "some updated name"
      assert topic.order == 43
    end

    test "update_topic/2 with invalid data returns error changeset" do
      topic = topic_fixture()
      assert {:error, %Ecto.Changeset{}} = Topics.update_topic(topic, @invalid_attrs)
      assert topic == Topics.get_topic!(topic.id)
    end

    test "delete_topic/1 deletes the topic" do
      topic = topic_fixture()
      assert {:ok, %Topic{}} = Topics.delete_topic(topic)
      assert_raise Ecto.NoResultsError, fn -> Topics.get_topic!(topic.id) end
    end

    test "change_topic/1 returns a topic changeset" do
      topic = topic_fixture()
      assert %Ecto.Changeset{} = Topics.change_topic(topic)
    end
  end
end
