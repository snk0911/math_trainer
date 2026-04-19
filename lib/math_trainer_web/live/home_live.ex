defmodule MathTrainerWeb.HomeLive do
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
     |> assign(:selected_category, nil)
     |> assign(:selected_topic, nil)
     |> assign(:selected_subtopic, nil)
     |> assign(:topics, [])
     |> assign(:subtopics, [])
     |> assign(:tasks, [])
     |> assign(:revealed, %{})}
  end

  @impl true
  def handle_event("select_category", %{"id" => id}, socket) do
    id = String.to_integer(id)
    category = Enum.find(socket.assigns.categories, &(&1.id == id))
    topics = Topics.list_topics_by_category(id)
    {:noreply,
     socket
     |> assign(:selected_category, category)
     |> assign(:selected_topic, nil)
     |> assign(:selected_subtopic, nil)
     |> assign(:topics, topics)
     |> assign(:subtopics, [])
     |> assign(:tasks, [])}
  end

  @impl true
  def handle_event("select_topic", %{"id" => id}, socket) do
    id = String.to_integer(id)
    topic = Enum.find(socket.assigns.topics, &(&1.id == id))
    subtopics = Subtopics.list_subtopics_by_topic(id)
    {:noreply,
     socket
     |> assign(:selected_topic, topic)
     |> assign(:selected_subtopic, nil)
     |> assign(:subtopics, subtopics)
     |> assign(:tasks, [])}
  end

  @impl true
  def handle_event("select_subtopic", %{"id" => id}, socket) do
    id = String.to_integer(id)
    subtopic = Enum.find(socket.assigns.subtopics, &(&1.id == id))
    tasks = Tasks.list_tasks_by_subtopic(id)
    {:noreply,
     socket
     |> assign(:selected_subtopic, subtopic)
     |> assign(:tasks, tasks)
     |> assign(:revealed, %{})}
  end

  @impl true
  def handle_event("back_to_categories", _, socket) do
    {:noreply,
     socket
     |> assign(:selected_category, nil)
     |> assign(:selected_topic, nil)
     |> assign(:selected_subtopic, nil)
     |> assign(:topics, [])
     |> assign(:subtopics, [])
     |> assign(:tasks, [])}
  end

  @impl true
  def handle_event("back_to_topics", _, socket) do
    {:noreply,
     socket
     |> assign(:selected_topic, nil)
     |> assign(:selected_subtopic, nil)
     |> assign(:subtopics, [])
     |> assign(:tasks, [])}
  end

  @impl true
  def handle_event("back_to_subtopics", _, socket) do
    {:noreply,
     socket
     |> assign(:selected_subtopic, nil)
     |> assign(:tasks, [])
     |> assign(:revealed, %{})}
  end

  @impl true
  def handle_event("reveal", %{"id" => id}, socket) do
    revealed = if Map.get(socket.assigns.revealed, id) do
      Map.delete(socket.assigns.revealed, id)
    else
      Map.put(socket.assigns.revealed, id, true)
    end
    {:noreply, assign(socket, :revealed, revealed)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="space-y-8">

        <%!-- Breadcrumbs --%>
        <div class="text-sm breadcrumbs text-base-content/50">
          <ul>
            <li>
              <button phx-click="back_to_categories" class="hover:text-base-content transition-colors">
                Kategorien
              </button>
            </li>
            <li :if={@selected_category}>
              <button phx-click="back_to_topics" class="hover:text-base-content transition-colors">
                {@selected_category.name}
              </button>
            </li>
            <li :if={@selected_topic}>
              <button phx-click="back_to_subtopics" class="hover:text-base-content transition-colors">
                {@selected_topic.name}
              </button>
            </li>
            <li :if={@selected_subtopic} class="text-base-content font-medium">
              {@selected_subtopic.name}
            </li>
          </ul>
        </div>

        <%!-- Categories --%>
        <div :if={is_nil(@selected_category)}>
          <h2 class="text-2xl font-bold mb-2">Kategorien</h2>
          <p class="text-base-content/50 text-sm mb-6">Wähle ein Themengebiet aus</p>
          <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
            <button
              :for={cat <- @categories}
              phx-click="select_category"
              phx-value-id={cat.id}
              class="card bg-base-200 hover:bg-base-300 transition-colors text-left p-6 border border-base-300 hover:border-primary"
            >
              <div class="text-2xl mb-2">📚</div>
              <div class="font-semibold text-base">{cat.name}</div>
            </button>
          </div>
        </div>

        <%!-- Topics --%>
        <div :if={@selected_category && is_nil(@selected_topic)}>
          <h2 class="text-2xl font-bold mb-2">{@selected_category.name}</h2>
          <p class="text-base-content/50 text-sm mb-6">Wähle ein Thema</p>
          <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
            <button
              :for={topic <- @topics}
              phx-click="select_topic"
              phx-value-id={topic.id}
              class="card bg-base-200 hover:bg-base-300 transition-colors text-left p-5 border border-base-300 hover:border-primary"
            >
              <div class="font-semibold">{topic.name}</div>
            </button>
          </div>
        </div>

        <%!-- Subtopics --%>
        <div :if={@selected_topic && is_nil(@selected_subtopic)}>
          <h2 class="text-2xl font-bold mb-2">{@selected_topic.name}</h2>
          <p class="text-base-content/50 text-sm mb-6">Wähle ein Unterthema</p>
          <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
            <button
              :for={subtopic <- @subtopics}
              phx-click="select_subtopic"
              phx-value-id={subtopic.id}
              class="card bg-base-200 hover:bg-base-300 transition-colors text-left p-5 border border-base-300 hover:border-primary"
            >
              <div class="font-semibold">{subtopic.name}</div>
            </button>
          </div>
        </div>

        <%!-- Tasks --%>
        <div :if={@selected_subtopic}>
          <h2 class="text-2xl font-bold mb-2">{@selected_subtopic.name}</h2>
          <p class="text-base-content/50 text-sm mb-6">
            <%= length(@tasks) %> Aufgabe<%= if length(@tasks) != 1, do: "n" %>
          </p>
          <p :if={@tasks == []} class="text-base-content/40 italic">Keine Aufgaben vorhanden.</p>
          <div class="space-y-4">
            <%= for task <- @tasks do %>
              <div class="card bg-base-200 border border-base-300">
                <div class="card-body gap-4">
                  <div class="flex items-center gap-2">
                    <span class="badge badge-primary badge-sm">Aufgabe <%= task.order %></span>
                  </div>
                  <p
                    class="text-base-content leading-relaxed"
                    id={"task-problem-#{task.id}"}
                    phx-hook="RenderMath"
                  ><%= task.problem %></p>

                  <%= if task.hint do %>
                    <div class="border-t border-dashed border-base-content/15 pt-3">
                      <p
                        class="text-sm italic text-base-content/60"
                        id={"task-hint-#{task.id}"}
                        phx-hook="RenderMath"
                      >Tipp: <%= task.hint %></p>
                    </div>
                  <% end %>

                  <%= if Map.get(@revealed, to_string(task.id)) do %>
                    <div class="border-t border-base-content/15 pt-3">
                      <p class="text-xs font-semibold text-base-content/40 uppercase tracking-wider mb-2">Lösung</p>
                      <p
                        class="text-success leading-relaxed"
                        id={"task-solution-#{task.id}"}
                        phx-hook="RenderMath"
                      ><%= task.solution %></p>
                    </div>
                  <% end %>

                  <div class="card-actions justify-end">
                    <button
                      phx-click="reveal"
                      phx-value-id={task.id}
                      class={["btn btn-sm", Map.get(@revealed, to_string(task.id)) && "btn-ghost", !Map.get(@revealed, to_string(task.id)) && "btn-primary"]}
                    >
                      <%= if Map.get(@revealed, to_string(task.id)), do: "Lösung verbergen", else: "Lösung zeigen" %>
                    </button>
                  </div>
                </div>
              </div>
            <% end %>
          </div>
        </div>

      </div>
    </Layouts.app>
    """
  end
end
