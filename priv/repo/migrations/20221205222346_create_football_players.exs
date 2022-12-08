defmodule NflRushing.Repo.Migrations.CreateFootballPlayers do
  use Ecto.Migration

  def change do
    create table(:football_players) do
      add :name, :string, null: false
      add :team, :string, null: false
      add :position, :string, null: false
      add :rushing_attempts_per_game_average, :float, null: false
      add :rushing_attempts, :integer, null: false
      add :total_rushing_yards, :integer, null: false
      add :rushing_average_yards_per_attempt, :float, null: false
      add :rushing_yards_per_game, :float, null: false
      add :total_rushing_touchdowns, :integer, null: false
      add :longest_rush, :integer, null: false
      add :longest_rush_touchdown, :boolean, default: false, null: false
      add :rushing_first_downs, :integer, null: false
      add :rushing_first_down_percentage, :float, null: false
      add :rushing_20plus_yards_each, :integer, null: false
      add :rushing_40plus_yards_each, :integer, null: false
      add :rushing_fumbles, :integer, null: false

      timestamps()
    end
  end
end
