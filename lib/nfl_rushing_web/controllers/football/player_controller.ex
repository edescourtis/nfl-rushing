defmodule NflRushingWeb.Football.PlayerController do
  use NflRushingWeb, :controller
  alias NflRushing.Football.PlayerRepo
  @default_page_size 100

  @spec players(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def players(conn, params) do
    limit =
      try do
        {limit, ""} = Integer.parse(Map.get(params, "limit"))
        limit
      catch
        _, _ -> @default_page_size
      end

    paginator_params = []

    paginator_params =
      if Map.has_key?(params, "after") do
        [{:after, Map.get(params, "after")} | paginator_params]
      else
        paginator_params
      end

    paginator_params =
      if Map.has_key?(params, "before") do
        [{:before, Map.get(params, "before")} | paginator_params]
      else
        paginator_params
      end

    {order, key} = get_sort_key(params)
    order_by_params = [{order, key}]

    cursor_fields =
      if key === :id do
        [:id]
      else
        [key, :id]
      end

    page = PlayerRepo.paginated_players(limit, paginator_params, cursor_fields, order_by_params)
    json(conn, page)
  end

  defp get_sort_key(%{"order_by" => "id"}) do
    {:asc, :id}
  end

  defp get_sort_key(%{"order_by" => "total_rushing_yards"}) do
    {:asc, :total_rushing_yards}
  end

  defp get_sort_key(%{"order_by" => "longest_rush"}) do
    {:asc, :longest_rush}
  end

  defp get_sort_key(%{"order_by" => "total_rushing_touchdowns"}) do
    {:asc, :total_rushing_touchdowns}
  end

  defp get_sort_key(%{}) do
    {:asc, :id}
  end
end
