defmodule MathTrainerWeb.TaskLive.Form do
  use MathTrainerWeb, :live_view
  alias MathTrainer.Tasks
  alias MathTrainer.Tasks.Task

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage task records in your database.</:subtitle>
      </.header>
      <.form for={@form} id="task-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:problem]} type="textarea" label="Problem" />
        <.input field={@form[:hint]} type="textarea" label="Hinweis (optional)" />
        <.input field={@form[:solution]} type="textarea" label="Lösung" />
        <.input field={@form[:order]} type="number" label="Order" />
        <.input field={@form[:subtopic_id]} type="select" label="Subtopic" options={@topic_options} />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Task</.button>
          <.button navigate={return_path(@return_to, @task)}>Cancel</.button>
        </footer>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    subtopics = MathTrainer.Subtopics.list_subtopics()
    subtopic_options = Enum.map(subtopics, &{&1.name, &1.id})
    {:ok,
    socket
    |> assign(:return_to, return_to(params["return_to"]))
    |> assign(:topic_options, subtopic_options)
    |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"id" => id}) do
    task = Tasks.get_task!(id)
    socket
    |> assign(:page_title, "Edit Task")
    |> assign(:task, task)
    |> assign(:form, to_form(Tasks.change_task(task)))
  end

  defp apply_action(socket, :new, _params) do
    task = %Task{}
    socket
    |> assign(:page_title, "New Task")
    |> assign(:task, task)
    |> assign(:form, to_form(Tasks.change_task(task)))
  end

  @impl true
  def handle_event("validate", %{"task" => task_params}, socket) do
    changeset = Tasks.change_task(socket.assigns.task, task_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"task" => task_params}, socket) do
    save_task(socket, socket.assigns.live_action, task_params)
  end

  defp save_task(socket, :edit, task_params) do
    case Tasks.update_task(socket.assigns.task, task_params) do
      {:ok, task} ->
        {:noreply,
         socket
         |> put_flash(:info, "Task updated successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, task))}
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_task(socket, :new, task_params) do
    case Tasks.create_task(task_params) do
      {:ok, task} ->
        {:noreply,
         socket
         |> put_flash(:info, "Task created successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, task))}
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path("index", _task), do: ~p"/tasks"
  defp return_path("show", task), do: ~p"/tasks/#{task}"
end
