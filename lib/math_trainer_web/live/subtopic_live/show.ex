defmodule MathTrainerWeb.SubtopicLive.Show do
  use MathTrainerWeb, :live_view

  alias MathTrainer.Subtopics

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Subtopic {@subtopic.id}
        <:subtitle>This is a subtopic record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/subtopics"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/subtopics/#{@subtopic}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit subtopic
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Name">{@subtopic.name}</:item>
        <:item title="Order">{@subtopic.order}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Subtopic")
     |> assign(:subtopic, Subtopics.get_subtopic!(id))}
  end
end
