defmodule MathTrainerWeb.SubtopicLiveTest do
  use MathTrainerWeb.ConnCase

  import Phoenix.LiveViewTest
  import MathTrainer.SubtopicsFixtures

  @create_attrs %{name: "some name", order: 42}
  @update_attrs %{name: "some updated name", order: 43}
  @invalid_attrs %{name: nil, order: nil}
  defp create_subtopic(_) do
    subtopic = subtopic_fixture()

    %{subtopic: subtopic}
  end

  describe "Index" do
    setup [:create_subtopic]

    test "lists all subtopics", %{conn: conn, subtopic: subtopic} do
      {:ok, _index_live, html} = live(conn, ~p"/subtopics")

      assert html =~ "Listing Subtopics"
      assert html =~ subtopic.name
    end

    test "saves new subtopic", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/subtopics")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Subtopic")
               |> render_click()
               |> follow_redirect(conn, ~p"/subtopics/new")

      assert render(form_live) =~ "New Subtopic"

      assert form_live
             |> form("#subtopic-form", subtopic: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#subtopic-form", subtopic: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/subtopics")

      html = render(index_live)
      assert html =~ "Subtopic created successfully"
      assert html =~ "some name"
    end

    test "updates subtopic in listing", %{conn: conn, subtopic: subtopic} do
      {:ok, index_live, _html} = live(conn, ~p"/subtopics")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#subtopics-#{subtopic.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/subtopics/#{subtopic}/edit")

      assert render(form_live) =~ "Edit Subtopic"

      assert form_live
             |> form("#subtopic-form", subtopic: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#subtopic-form", subtopic: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/subtopics")

      html = render(index_live)
      assert html =~ "Subtopic updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes subtopic in listing", %{conn: conn, subtopic: subtopic} do
      {:ok, index_live, _html} = live(conn, ~p"/subtopics")

      assert index_live |> element("#subtopics-#{subtopic.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#subtopics-#{subtopic.id}")
    end
  end

  describe "Show" do
    setup [:create_subtopic]

    test "displays subtopic", %{conn: conn, subtopic: subtopic} do
      {:ok, _show_live, html} = live(conn, ~p"/subtopics/#{subtopic}")

      assert html =~ "Show Subtopic"
      assert html =~ subtopic.name
    end

    test "updates subtopic and returns to show", %{conn: conn, subtopic: subtopic} do
      {:ok, show_live, _html} = live(conn, ~p"/subtopics/#{subtopic}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/subtopics/#{subtopic}/edit?return_to=show")

      assert render(form_live) =~ "Edit Subtopic"

      assert form_live
             |> form("#subtopic-form", subtopic: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#subtopic-form", subtopic: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/subtopics/#{subtopic}")

      html = render(show_live)
      assert html =~ "Subtopic updated successfully"
      assert html =~ "some updated name"
    end
  end
end
