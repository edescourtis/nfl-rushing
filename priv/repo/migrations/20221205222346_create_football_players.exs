defmodule NflRushing.Repo.Migrations.CreateFootballPlayers do
  use Ecto.Migration

  def change do
    create table(:football_players) do
      add :name, :string
      add :team, :string
      add :position, :string
      add :rushing_attempts_per_game_average, :float
      add :rushing_attempts, :integer
      add :total_rushing_yards, :integer
      add :rushing_average_yards_per_attempt, :float
      add :rushing_yards_per_game, :float
      add :total_rushing_touchdowns, :integer
      add :longest_rush, :integer
      add :longest_rush_touchdown, :boolean, default: false, null: false
      add :rushing_first_downs, :integer
      add :rushing_first_down_percentage, :float
      add :rushing_20plus_yards_each, :integer
      add :rushing_40plus_yards_each, :integer
      add :rushing_fumbles, :integer

      timestamps()
    end
  end
end
