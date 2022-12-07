defmodule NflRushing.Football.Player do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, except: [:__meta__]}
  schema "football_players" do
    field :longest_rush, :integer
    field :longest_rush_touchdown, :boolean, default: false
    field :name, :string
    field :position, :string
    field :rushing_20plus_yards_each, :integer
    field :rushing_40plus_yards_each, :integer
    field :rushing_attempts, :integer
    field :rushing_attempts_per_game_average, :float
    field :rushing_average_yards_per_attempt, :float
    field :rushing_first_down_percentage, :float
    field :rushing_first_downs, :integer
    field :rushing_fumbles, :integer
    field :rushing_yards_per_game, :float
    field :team, :string
    field :total_rushing_touchdowns, :integer
    field :total_rushing_yards, :integer

    timestamps()
  end

  @doc false
  def changeset(player, attrs) do
    player
    |> cast(attrs, [:name, :team, :position, :rushing_attempts_per_game_average, :rushing_attempts, :total_rushing_yards, :rushing_average_yards_per_attempt, :rushing_yards_per_game, :total_rushing_touchdowns, :longest_rush, :longest_rush_touchdown, :rushing_first_downs, :rushing_first_down_percentage, :rushing_20plus_yards_each, :rushing_40plus_yards_each, :rushing_fumbles])
    |> validate_required([:name, :team, :position, :rushing_attempts_per_game_average, :rushing_attempts, :total_rushing_yards, :rushing_average_yards_per_attempt, :rushing_yards_per_game, :total_rushing_touchdowns, :longest_rush, :longest_rush_touchdown, :rushing_first_downs, :rushing_first_down_percentage, :rushing_20plus_yards_each, :rushing_40plus_yards_each, :rushing_fumbles])
  end
end
