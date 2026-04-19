defmodule MathTrainerWeb.PageController do
  use MathTrainerWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
