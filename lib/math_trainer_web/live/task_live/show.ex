defmodule MathTrainerWeb.TaskLive.Show do
  use MathTrainerWeb, :live_view

  alias MathTrainer.Tasks

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Task {@task.id}
        <:subtitle>This is a task record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/tasks"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/tasks/#{@task}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit task
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Problem">{@task.problem}</:item>
        <:item title="Hinweis">{@task.hint}</:item>
        <:item title="Lösung">{@task.solution}</:item>
        <:item title="Order">{@task.order}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Task")
     |> assign(:task, Tasks.get_task!(id))}
  end
end
