defmodule NflRushing.Football.PlayerImport do
  @moduledoc """
  Utilities to load json data into the Repo.
  """
  alias NflRushing.Repo
  alias NflRushing.Football.Player
  alias Ecto.Changeset

  @batch_size 100

  # TODO: Fix return type it does return :ok most of the time
  @doc ~S"""
    Load football players from ndjson file into the DB.

    filename: file should be in the priv directory
  """
  @spec load_ndjson!() :: no_return
  @spec load_ndjson!(filename :: String.t()) :: no_return
  def load_ndjson!(filename \\ "rushing.ndjson")
  def load_ndjson!(filename) do
    delete_all()
    path = Path.join(:code.priv_dir(:nfl_rushing), filename)
    File.stream!(path, [:read_ahead, :utf8], :line)
    |> Stream.chunk_every(@batch_size)
    |> Stream.each(
      fn football_player_jsons ->
        datetime = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
        players = for football_player_json <- football_player_jsons do
          to_normalized_player_map!(football_player_json, datetime)
        end
        Repo.insert_all(Player, players)
      end)
    |> Stream.run()
  end

  @doc ~S"""
  Creates a normalized player map for Repo.insert_all/2

  ## Examples
      iex> NflRushing.Football.PlayerImport.to_normalized_player_map!(~s({"Player":"Joe Banyard","Team":"JAX","Pos":"RB","Att":2,"Att/G":2,"Yds":7,"Avg":3.5,"Yds/G":7,"TD":0,"Lng":"7","1st":0,"1st%":0,"20+":0,"40+":0,"FUM":0}), ~N[2022-12-06 08:04:38])
      %{
        inserted_at: ~N[2022-12-06 08:04:38],
        longest_rush: 7,
        longest_rush_touchdown: false,
        name: "Joe Banyard",
        position: "RB",
        rushing_20plus_yards_each: 0,
        rushing_40plus_yards_each: 0,
        rushing_attempts: 2,
        rushing_attempts_per_game_average: 2.0,
        rushing_average_yards_per_attempt: 3.5,
        rushing_first_down_percentage: 0.0,
        rushing_first_downs: 0,
        rushing_fumbles: 0,
        rushing_yards_per_game: 7.0,
        team: "JAX",
        total_rushing_touchdowns: 0,
        total_rushing_yards: 7,
        updated_at: ~N[2022-12-06 08:04:38]
      }

      iex> NflRushing.Football.PlayerImport.to_normalized_player_map!(~s({"Player":"Joe Banyard","Team":"JAX","Pos":"RB","Att":2,"Att/G":2,"Yds":"1,079","Avg":3.5,"Yds/G":7,"TD":0,"Lng":"7","1st":0,"1st%":0,"20+":0,"40+":0,"FUM":0}), ~N[2022-12-06 08:04:38]) |> Map.get(:total_rushing_yards)
      1079
  """
  def to_normalized_player_map!(football_player_json, datetime \\ NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)) do
    football_player_raw = Jason.decode!(football_player_json)
    football_player = json_to_schema_player(football_player_raw)
    Player.changeset(%Player{}, football_player)
      |> Changeset.apply_changes()
      |> Map.from_struct()
      |> Map.put(:inserted_at, datetime)
      |> Map.put(:updated_at, datetime)
      |> Map.delete(:id)
      |> Map.delete(:__meta__)
  end

  def delete_all() do
    Repo.delete_all(Player)
  end

  defp json_to_schema_player(%{
    "Player" => name,
    "Team" => team,
    "Pos" => position,
    "Att/G" => rushing_attempts_per_game_average,
    "Att" => rushing_attempts,
    "Yds" => total_rushing_yards,
    "Avg" => rushing_average_yards_per_attempt,
    "Yds/G" => rushing_yards_per_game,
    "TD" => total_rushing_touchdowns,
    "Lng" => longest_rush_with_maybe_touchdown,
    "1st" => rushing_first_downs,
    "1st%" => rushing_first_down_percentage,
    "20+" => rushing_20plus_yards_each,
    "40+" => rushing_40plus_yards_each,
    "FUM" => rushing_fumbles
  }) do
    {longest_rush, longest_rush_touchdown} = case Integer.parse("#{longest_rush_with_maybe_touchdown}") do
      {longest_rush, ""} -> {longest_rush, false}
      {longest_rush, "T"} -> {longest_rush, true}
    end

    %{
      name: name,
      team: team,
      position: position,
      rushing_attempts_per_game_average: rushing_attempts_per_game_average |> fix_integer(),
      rushing_attempts: rushing_attempts |> fix_integer(),
      total_rushing_yards: total_rushing_yards |> fix_integer(),
      rushing_average_yards_per_attempt: rushing_average_yards_per_attempt |> fix_integer(),
      rushing_yards_per_game: rushing_yards_per_game |> fix_integer(),
      total_rushing_touchdowns: total_rushing_touchdowns  |> fix_integer(),
      longest_rush: longest_rush |> fix_integer(),
      longest_rush_touchdown: longest_rush_touchdown,
      rushing_first_downs: rushing_first_downs |> fix_integer(),
      rushing_first_down_percentage: rushing_first_down_percentage |> fix_integer(),
      rushing_20plus_yards_each: rushing_20plus_yards_each |> fix_integer(),
      rushing_40plus_yards_each: rushing_40plus_yards_each |> fix_integer(),
      rushing_fumbles: rushing_fumbles |> fix_integer()
    }
  end

  defp fix_integer(n) when is_integer(n) or is_float(n), do: n
  defp fix_integer(s) when is_binary(s), do: String.replace(s, ",", "")
end
