defmodule NflRushing.Repo.Migrations.AddSortIndexes do
  use Ecto.Migration

  def change do
    create index(:football_players, [:total_rushing_yards, :id])
    create index(:football_players, [:longest_rush, :id])
    create index(:football_players, [:total_rushing_touchdowns, :id])
  end
end
