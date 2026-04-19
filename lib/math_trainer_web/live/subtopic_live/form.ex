defmodule MathTrainerWeb.SubtopicLive.Form do
  use MathTrainerWeb, :live_view
  alias MathTrainer.Subtopics
  alias MathTrainer.Subtopics.Subtopic

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage subtopic records in your database.</:subtitle>
      </.header>
      <.form for={@form} id="subtopic-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:order]} type="number" label="Order" />
        <.input field={@form[:topic_id]} type="select" label="Topic" options={@topic_options} />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Subtopic</.button>
          <.button navigate={return_path(@return_to, @subtopic)}>Cancel</.button>
        </footer>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    topics = MathTrainer.Topics.list_topics()
    topic_options = Enum.map(topics, &{&1.name, &1.id})
    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> assign(:topic_options, topic_options)
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"id" => id}) do
    subtopic = Subtopics.get_subtopic!(id)
    socket
    |> assign(:page_title, "Edit Subtopic")
    |> assign(:subtopic, subtopic)
    |> assign(:form, to_form(Subtopics.change_subtopic(subtopic)))
  end

  defp apply_action(socket, :new, _params) do
    subtopic = %Subtopic{}
    socket
    |> assign(:page_title, "New Subtopic")
    |> assign(:subtopic, subtopic)
    |> assign(:form, to_form(Subtopics.change_subtopic(subtopic)))
  end

  @impl true
  def handle_event("validate", %{"subtopic" => subtopic_params}, socket) do
    changeset = Subtopics.change_subtopic(socket.assigns.subtopic, subtopic_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"subtopic" => subtopic_params}, socket) do
    save_subtopic(socket, socket.assigns.live_action, subtopic_params)
  end

  defp save_subtopic(socket, :edit, subtopic_params) do
    case Subtopics.update_subtopic(socket.assigns.subtopic, subtopic_params) do
      {:ok, subtopic} ->
        {:noreply,
         socket
         |> put_flash(:info, "Subtopic updated successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, subtopic))}
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_subtopic(socket, :new, subtopic_params) do
    case Subtopics.create_subtopic(subtopic_params) do
      {:ok, subtopic} ->
        {:noreply,
         socket
         |> put_flash(:info, "Subtopic created successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, subtopic))}
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path("index", _subtopic), do: ~p"/subtopics"
  defp return_path("show", subtopic), do: ~p"/subtopics/#{subtopic}"
end
