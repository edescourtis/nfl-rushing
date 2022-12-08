defmodule NflRushing.Repo do
  use Ecto.Repo,
    otp_app: :nfl_rushing,
    adapter: Ecto.Adapters.Postgres

  use Paginator
end
