defmodule MathTrainer.Repo do
  use Ecto.Repo,
    otp_app: :math_trainer,
    adapter: Ecto.Adapters.SQLite3
end
