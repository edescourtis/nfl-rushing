defmodule NflRushing.Football.PlayerRepo do
  use CachexMemoize
  import Ecto.Query
  alias NflRushing.Football.Player
  alias NflRushing.Repo
  @max_page_size 100

  @football_players_pagination_cache :football_players_pagination_cache

  def get_football_players_pagination_cache() do
    @football_players_pagination_cache
  end

  @spec paginated_players(pos_integer(), list(), list(), list()) :: %{
          data: list(Player.t()),
          meta: %{after: nil | binary, before: nil | binary}
        }
  defmemo paginated_players(limit, paginator_params, cursor_fields, order_by_params),
    cache: :football_players_pagination_cache,
    ttl: :timer.hours(1) do
    %Paginator.Page{entries: players, metadata: metadata} =
      Repo.paginate(
        from(p in Player) |> order_by(^order_by_params),
        [
          cursor_fields: cursor_fields,
          limit: limit,
          maximum_limit: @max_page_size
        ] ++ paginator_params
      )

    %{data: players, meta: %{before: metadata.before, after: metadata.after}}
  end
end
