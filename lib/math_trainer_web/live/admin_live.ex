defmodule MathTrainerWeb.AdminLive do
  use MathTrainerWeb, :live_view
  alias MathTrainer.Categories
  alias MathTrainer.Topics
  alias MathTrainer.Subtopics
  alias MathTrainer.Tasks

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:categories, Categories.list_categories())
     |> assign(:topics, Topics.list_topics())
     |> assign(:subtopics, Subtopics.list_subtopics())
     |> assign(:tasks, Tasks.list_tasks())
     |> assign(:expanded_category, nil)
     |> assign(:expanded_topic, nil)
     |> assign(:expanded_subtopic, nil)
     |> assign(:panel, nil)
     |> assign(:panel_data, %{})
     |> assign(:preview_problem, "")
     |> assign(:preview_hint, "")
     |> assign(:preview_solution, "")
     |> assign(:last_saved_id, nil)}
  end

  defp reload(socket) do
    socket
    |> assign(:categories, Categories.list_categories())
    |> assign(:topics, Topics.list_topics())
    |> assign(:subtopics, Subtopics.list_subtopics())
    |> assign(:tasks, Tasks.list_tasks())
  end

  defp close_panel(socket) do
    socket
    |> assign(:panel, nil)
    |> assign(:panel_data, %{})
    |> assign(:preview_problem, "")
    |> assign(:preview_hint, "")
    |> assign(:preview_solution, "")
  end

  @impl true
  def handle_event("toggle_category", %{"id" => id}, socket) do
    id = String.to_integer(id)
    expanded = if socket.assigns.expanded_category == id, do: nil, else: id
    {:noreply,
     socket
     |> assign(:expanded_category, expanded)
     |> assign(:expanded_topic, nil)
     |> assign(:expanded_subtopic, nil)}
  end

  def handle_event("toggle_topic", %{"id" => id}, socket) do
    id = String.to_integer(id)
    expanded = if socket.assigns.expanded_topic == id, do: nil, else: id
    {:noreply,
     socket
     |> assign(:expanded_topic, expanded)
     |> assign(:expanded_subtopic, nil)}
  end

  def handle_event("toggle_subtopic", %{"id" => id}, socket) do
    id = String.to_integer(id)
    expanded = if socket.assigns.expanded_subtopic == id, do: nil, else: id
    {:noreply, assign(socket, :expanded_subtopic, expanded)}
  end

  def handle_event("new_category", _, socket) do
    {:noreply,
     socket
     |> assign(:panel, :new_category)
     |> assign(:panel_data, %{})
     |> assign(:preview_problem, "")
     |> assign(:preview_hint, "")
     |> assign(:preview_solution, "")}
  end

  def handle_event("new_topic", %{"category_id" => id}, socket) do
    {:noreply,
     socket
     |> assign(:panel, :new_topic)
     |> assign(:panel_data, %{"category_id" => id})
     |> assign(:preview_problem, "")
     |> assign(:preview_hint, "")
     |> assign(:preview_solution, "")}
  end

  def handle_event("new_subtopic", %{"topic_id" => id}, socket) do
    {:noreply,
     socket
     |> assign(:panel, :new_subtopic)
     |> assign(:panel_data, %{"topic_id" => id})
     |> assign(:preview_problem, "")
     |> assign(:preview_hint, "")
     |> assign(:preview_solution, "")}
  end

  def handle_event("new_task", %{"subtopic_id" => id}, socket) do
    {:noreply,
     socket
     |> assign(:panel, :new_task)
     |> assign(:panel_data, %{"subtopic_id" => id})
     |> assign(:preview_problem, "")
     |> assign(:preview_hint, "")
     |> assign(:preview_solution, "")}
  end

  def handle_event("open_task", %{"id" => id}, socket) do
    task = Tasks.get_task!(String.to_integer(id))
    {:noreply,
     socket
     |> assign(:panel, :edit_task)
     |> assign(:panel_data, %{"task" => task})
     |> assign(:preview_problem, task.problem || "")
     |> assign(:preview_hint, task.hint || "")
     |> assign(:preview_solution, task.solution || "")}
  end

  def handle_event("close_panel", _, socket) do
    {:noreply, close_panel(socket)}
  end

  def handle_event("save_category", %{"name" => name, "order" => order}, socket) do
    case Categories.create_category(%{name: name, order: order}) do
      {:ok, cat} ->
        {:noreply, socket |> reload() |> close_panel() |> assign(:last_saved_id, {:category, cat.id}) |> put_flash(:info, "Kategorie gespeichert ✓")}
      {:error, _} ->
        {:noreply, put_flash(socket, :error, "Fehler beim Speichern")}
    end
  end

  def handle_event("save_topic", %{"name" => name, "order" => order, "category_id" => cat_id}, socket) do
    case Topics.create_topic(%{name: name, order: order, category_id: cat_id}) do
      {:ok, topic} ->
        {:noreply, socket |> reload() |> close_panel() |> assign(:last_saved_id, {:topic, topic.id}) |> put_flash(:info, "Thema gespeichert ✓")}
      {:error, _} ->
        {:noreply, put_flash(socket, :error, "Fehler beim Speichern")}
    end
  end

  def handle_event("save_subtopic", %{"name" => name, "order" => order, "topic_id" => topic_id}, socket) do
    case Subtopics.create_subtopic(%{name: name, order: order, topic_id: topic_id}) do
      {:ok, sub} ->
        {:noreply, socket |> reload() |> close_panel() |> assign(:last_saved_id, {:subtopic, sub.id}) |> put_flash(:info, "Unterthema gespeichert ✓")}
      {:error, _} ->
        {:noreply, put_flash(socket, :error, "Fehler beim Speichern")}
    end
  end

  def handle_event("save_task", params, socket) do
    %{"problem" => problem, "hint" => hint, "solution" => solution, "order" => order, "subtopic_id" => subtopic_id} = params

    result = case socket.assigns.panel do
      :edit_task ->
        task = socket.assigns.panel_data["task"]
        Tasks.update_task(task, %{problem: problem, hint: hint, solution: solution, order: order, subtopic_id: subtopic_id})
      _ ->
        Tasks.create_task(%{problem: problem, hint: hint, solution: solution, order: order, subtopic_id: subtopic_id})
    end

    case result do
      {:ok, task} ->
        {:noreply, socket |> reload() |> close_panel() |> assign(:last_saved_id, {:task, task.id}) |> put_flash(:info, "Aufgabe gespeichert ✓")}
      {:error, _} ->
        {:noreply, put_flash(socket, :error, "Fehler beim Speichern")}
    end
  end

  def handle_event("delete_category", %{"id" => id}, socket) do
    category = Categories.get_category!(String.to_integer(id))
    Categories.delete_category(category)
    {:noreply, socket |> reload() |> put_flash(:info, "Kategorie gelöscht")}
  end

  def handle_event("delete_topic", %{"id" => id}, socket) do
    topic = Topics.get_topic!(String.to_integer(id))
    Topics.delete_topic(topic)
    {:noreply, socket |> reload() |> put_flash(:info, "Thema gelöscht")}
  end

  def handle_event("delete_subtopic", %{"id" => id}, socket) do
    subtopic = Subtopics.get_subtopic!(String.to_integer(id))
    Subtopics.delete_subtopic(subtopic)
    {:noreply, socket |> reload() |> put_flash(:info, "Unterthema gelöscht")}
  end

  def handle_event("delete_task", %{"id" => id}, socket) do
    task = Tasks.get_task!(String.to_integer(id))
    Tasks.delete_task(task)
    {:noreply, socket |> reload() |> put_flash(:info, "Aufgabe gelöscht")}
  end

  def handle_event("preview_update", %{"problem" => problem, "hint" => hint, "solution" => solution}, socket) do
    {:noreply,
     socket
     |> assign(:preview_problem, problem)
     |> assign(:preview_hint, hint)
     |> assign(:preview_solution, solution)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} full_width={true}>
      <div class="flex h-full overflow-hidden">

        <%!-- PANEL 1: Struktur (fixed width) --%>
        <div class="w-72 shrink-0 border-r border-base-300 flex flex-col h-full">
          <div class="flex items-center justify-between px-4 h-12 border-b border-base-300 shrink-0">
            <span class="font-bold text-sm">Struktur</span>
            <button phx-click="new_category" class="btn btn-primary btn-xs">+ Kategorie</button>
          </div>
          <div class="overflow-y-auto flex-1 px-2 py-2 space-y-0.5">
            <%= for category <- @categories do %>
              <div>
                <div class={["flex items-center justify-between rounded px-2 py-1.5 group hover:bg-base-200", @last_saved_id == {:category, category.id} && "bg-success/10"]}>
                  <button phx-click="toggle_category" phx-value-id={category.id} class="flex items-center gap-1.5 flex-1 text-left text-sm font-semibold truncate">
                    <span class={["text-xs transition-transform shrink-0", @expanded_category == category.id && "rotate-90"]}>▶</span>
                    <%= category.name %>
                  </button>
                  <div class="flex gap-0.5 opacity-0 group-hover:opacity-100 shrink-0">
                    <button phx-click="new_topic" phx-value-category_id={category.id} class="btn btn-xs btn-ghost px-1">+</button>
                    <button phx-click="delete_category" phx-value-id={category.id} data-confirm="Sicher?" class="btn btn-xs btn-ghost px-1 text-error">✕</button>
                  </div>
                </div>
                <div :if={@expanded_category == category.id} class="ml-3 border-l border-base-300 pl-2 mt-0.5 space-y-0.5">
                  <%= for topic <- Enum.filter(@topics, & &1.category_id == category.id) do %>
                    <div>
                      <div class={["flex items-center justify-between rounded px-2 py-1.5 group hover:bg-base-200", @last_saved_id == {:topic, topic.id} && "bg-success/10"]}>
                        <button phx-click="toggle_topic" phx-value-id={topic.id} class="flex items-center gap-1.5 flex-1 text-left text-sm truncate">
                          <span class={["text-xs transition-transform shrink-0", @expanded_topic == topic.id && "rotate-90"]}>▶</span>
                          <%= topic.name %>
                        </button>
                        <div class="flex gap-0.5 opacity-0 group-hover:opacity-100 shrink-0">
                          <button phx-click="new_subtopic" phx-value-topic_id={topic.id} class="btn btn-xs btn-ghost px-1">+</button>
                          <button phx-click="delete_topic" phx-value-id={topic.id} data-confirm="Sicher?" class="btn btn-xs btn-ghost px-1 text-error">✕</button>
                        </div>
                      </div>
                      <div :if={@expanded_topic == topic.id} class="ml-3 border-l border-base-300 pl-2 mt-0.5 space-y-0.5">
                        <%= for subtopic <- Enum.filter(@subtopics, & &1.topic_id == topic.id) do %>
                          <div>
                            <div class={["flex items-center justify-between rounded px-2 py-1.5 group hover:bg-base-200", @last_saved_id == {:subtopic, subtopic.id} && "bg-success/10"]}>
                              <button phx-click="toggle_subtopic" phx-value-id={subtopic.id} class="flex items-center gap-1.5 flex-1 text-left text-sm truncate">
                                <span class={["text-xs transition-transform shrink-0", @expanded_subtopic == subtopic.id && "rotate-90"]}>▶</span>
                                <%= subtopic.name %>
                              </button>
                              <div class="flex gap-0.5 opacity-0 group-hover:opacity-100 shrink-0">
                                <button phx-click="new_task" phx-value-subtopic_id={subtopic.id} class="btn btn-xs btn-ghost px-1">+</button>
                                <button phx-click="delete_subtopic" phx-value-id={subtopic.id} data-confirm="Sicher?" class="btn btn-xs btn-ghost px-1 text-error">✕</button>
                              </div>
                            </div>
                            <div :if={@expanded_subtopic == subtopic.id} class="ml-3 border-l border-base-300 pl-2 mt-0.5 space-y-0.5">
                              <%= for task <- Enum.filter(@tasks, & &1.subtopic_id == subtopic.id) do %>
                                <div class={["flex items-center justify-between rounded px-2 py-1 group hover:bg-base-200", @last_saved_id == {:task, task.id} && "bg-success/10"]}>
                                  <button phx-click="open_task" phx-value-id={task.id} class="text-xs text-base-content/60 flex-1 text-left truncate hover:text-base-content">
                                    <%= task.order %>. <%= String.slice(task.problem, 0, 25) %>...
                                  </button>
                                  <button phx-click="delete_task" phx-value-id={task.id} data-confirm="Sicher?" class="btn btn-xs btn-ghost px-1 text-error opacity-0 group-hover:opacity-100 shrink-0">✕</button>
                                </div>
                              <% end %>
                            </div>
                          </div>
                        <% end %>
                      </div>
                    </div>
                  <% end %>
                </div>
              </div>
            <% end %>
          </div>
        </div>

        <%!-- PANEL 2: Editor (flexible) --%>
        <div class="flex-1 border-r border-base-300 flex flex-col h-full min-w-0">
          <div class="flex items-center justify-between px-6 h-12 border-b border-base-300 shrink-0">
            <span class="font-bold text-sm">
              <%= case @panel do
                :new_category -> "Neue Kategorie"
                :new_topic -> "Neues Thema"
                :new_subtopic -> "Neues Unterthema"
                :new_task -> "Neue Aufgabe"
                :edit_task -> "Aufgabe bearbeiten"
                _ -> "Editor"
              end %>
            </span>
            <button :if={@panel} phx-click="close_panel" class="btn btn-ghost btn-xs">✕</button>
          </div>

          <div class="flex-1 overflow-y-auto px-6 py-6">
            <%!-- Empty --%>
            <div :if={is_nil(@panel)} class="flex flex-col items-center justify-center h-full text-base-content/20">
              <p class="text-5xl mb-3">←</p>
              <p class="text-sm">Wähle ein Element aus der Struktur</p>
            </div>

            <%!-- New Category --%>
            <form :if={@panel == :new_category} phx-submit="save_category" class="space-y-5 max-w-md">
              <div>
                <label class="label text-sm font-medium">Name</label>
                <input type="text" name="name" class="input input-bordered w-full" required autofocus />
              </div>
              <div>
                <label class="label text-sm font-medium">Reihenfolge</label>
                <input type="number" name="order" class="input input-bordered w-32" required />
              </div>
              <button type="submit" class="btn btn-primary">Speichern</button>
            </form>

            <%!-- New Topic --%>
            <form :if={@panel == :new_topic} phx-submit="save_topic" class="space-y-5 max-w-md">
              <input type="hidden" name="category_id" value={@panel_data["category_id"]} />
              <div>
                <label class="label text-sm font-medium">Name</label>
                <input type="text" name="name" class="input input-bordered w-full" required autofocus />
              </div>
              <div>
                <label class="label text-sm font-medium">Reihenfolge</label>
                <input type="number" name="order" class="input input-bordered w-32" required />
              </div>
              <button type="submit" class="btn btn-primary">Speichern</button>
            </form>

            <%!-- New Subtopic --%>
            <form :if={@panel == :new_subtopic} phx-submit="save_subtopic" class="space-y-5 max-w-md">
              <input type="hidden" name="topic_id" value={@panel_data["topic_id"]} />
              <div>
                <label class="label text-sm font-medium">Name</label>
                <input type="text" name="name" class="input input-bordered w-full" required autofocus />
              </div>
              <div>
                <label class="label text-sm font-medium">Reihenfolge</label>
                <input type="number" name="order" class="input input-bordered w-32" required />
              </div>
              <button type="submit" class="btn btn-primary">Speichern</button>
            </form>

            <%!-- New / Edit Task --%>
            <form :if={@panel in [:new_task, :edit_task]} phx-submit="save_task" phx-change="preview_update" class="space-y-5 max-w-2xl">
              <input type="hidden" name="subtopic_id" value={
                if @panel == :edit_task,
                  do: @panel_data["task"].subtopic_id,
                  else: @panel_data["subtopic_id"]
              } />
              <div>
                <label class="label text-sm font-medium">Problem</label>
                <textarea name="problem" class="textarea textarea-bordered w-full font-mono text-sm" rows="8" required><%= @preview_problem %></textarea>
                <p class="text-xs text-base-content/30 mt-1">LaTeX: $inline$ oder $$block$$</p>
              </div>
              <div>
                <label class="label text-sm font-medium">
                  Hinweis <span class="text-base-content/30 font-normal ml-1 text-xs">(optional)</span>
                </label>
                <textarea name="hint" class="textarea textarea-bordered w-full text-sm" rows="3"><%= @preview_hint %></textarea>
              </div>
              <div>
                <label class="label text-sm font-medium">Lösung</label>
                <textarea name="solution" class="textarea textarea-bordered w-full font-mono text-sm" rows="8" required><%= @preview_solution %></textarea>
              </div>
              <div>
                <label class="label text-sm font-medium">Reihenfolge</label>
                <input
                  type="number"
                  name="order"
                  class="input input-bordered w-32"
                  value={if @panel == :edit_task, do: @panel_data["task"].order, else: ""}
                  required
                />
              </div>
              <button type="submit" class="btn btn-primary">Speichern</button>
            </form>
          </div>
        </div>

        <%!-- PANEL 3: Vorschau (fixed width) --%>
        <div class="w-96 shrink-0 flex flex-col h-full">
          <div class="px-6 h-12 flex items-center border-b border-base-300 shrink-0">
            <span class="font-bold text-sm">Vorschau</span>
          </div>
          <div class="flex-1 overflow-y-auto px-6 py-5">
            <div :if={@preview_problem == ""} class="flex flex-col items-center justify-center h-full text-base-content/20">
              <p class="text-4xl mb-3">👁</p>
              <p class="text-sm">Vorschau erscheint beim Tippen</p>
            </div>
            <div :if={@preview_problem != ""} class="card bg-base-200 p-5 space-y-4">
              <p class="text-base-content leading-relaxed" id="admin-preview-problem" phx-hook="RenderMath">
                <%= @preview_problem %>
              </p>
              <div :if={@preview_hint != ""} class="border-t border-dashed border-base-content/20 pt-4">
                <p class="text-sm italic text-base-content/60" id="admin-preview-hint" phx-hook="RenderMath">
                  Tipp: <%= @preview_hint %>
                </p>
              </div>
              <div :if={@preview_solution != ""}>
                <div class="divider text-xs text-base-content/30">Lösung</div>
                <p class="text-success leading-relaxed" id="admin-preview-solution" phx-hook="RenderMath">
                  <%= @preview_solution %>
                </p>
              </div>
            </div>
          </div>
        </div>

      </div>
    </Layouts.app>
    """
  end
end
