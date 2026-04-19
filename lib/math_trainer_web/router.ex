defmodule MathTrainerWeb.Router do
  use MathTrainerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {MathTrainerWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MathTrainerWeb do
    pipe_through :browser

    live "/", HomeLive, :index
    live "/admin", AdminLive, :index
    live "/categories", CategoryLive.Index, :index
    live "/categories/new", CategoryLive.Form, :new
    live "/categories/:id", CategoryLive.Show, :show
    live "/categories/:id/edit", CategoryLive.Form, :edit
    live "/topics", TopicLive.Index, :index
    live "/topics/new", TopicLive.Form, :new
    live "/topics/:id", TopicLive.Show, :show
    live "/topics/:id/edit", TopicLive.Form, :edit
    live "/subtopics", SubtopicLive.Index, :index
    live "/subtopics/new", SubtopicLive.Form, :new
    live "/subtopics/:id", SubtopicLive.Show, :show
    live "/subtopics/:id/edit", SubtopicLive.Form, :edit
    live "/tasks", TaskLive.Index, :index
    live "/tasks/new", TaskLive.Form, :new
    live "/tasks/:id", TaskLive.Show, :show
    live "/tasks/:id/edit", TaskLive.Form, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", MathTrainerWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:math_trainer, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: MathTrainerWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
