defmodule MathTrainerWeb.TopicLive.Show do
  use MathTrainerWeb, :live_view

  alias MathTrainer.Topics

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Topic {@topic.id}
        <:subtitle>This is a topic record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/topics"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/topics/#{@topic}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit topic
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Name">{@topic.name}</:item>
        <:item title="Order">{@topic.order}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Topic")
     |> assign(:topic, Topics.get_topic!(id))}
  end
end
