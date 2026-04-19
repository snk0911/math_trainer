defmodule MathTrainerWeb.SubtopicLive.Index do
  use MathTrainerWeb, :live_view

  alias MathTrainer.Subtopics

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Listing Subtopics
        <:actions>
          <.button variant="primary" navigate={~p"/subtopics/new"}>
            <.icon name="hero-plus" /> New Subtopic
          </.button>
        </:actions>
      </.header>

      <.table
        id="subtopics"
        rows={@streams.subtopics}
        row_click={fn {_id, subtopic} -> JS.navigate(~p"/subtopics/#{subtopic}") end}
      >
        <:col :let={{_id, subtopic}} label="Name">{subtopic.name}</:col>
        <:col :let={{_id, subtopic}} label="Order">{subtopic.order}</:col>
        <:action :let={{_id, subtopic}}>
          <div class="sr-only">
            <.link navigate={~p"/subtopics/#{subtopic}"}>Show</.link>
          </div>
          <.link navigate={~p"/subtopics/#{subtopic}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, subtopic}}>
          <.link
            phx-click={JS.push("delete", value: %{id: subtopic.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Listing Subtopics")
     |> stream(:subtopics, list_subtopics())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    subtopic = Subtopics.get_subtopic!(id)
    {:ok, _} = Subtopics.delete_subtopic(subtopic)

    {:noreply, stream_delete(socket, :subtopics, subtopic)}
  end

  defp list_subtopics() do
    Subtopics.list_subtopics()
  end
end
