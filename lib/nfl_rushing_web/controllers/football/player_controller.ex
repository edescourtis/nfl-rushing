defmodule NflRushingWeb.Football.PlayerController do

  use NflRushingWeb, :controller

  alias NflRushing.Football.Player
  alias NflRushing.Repo


  @spec players(Plug.Conn.t(), any) :: Plug.Conn.t()
  def players(conn, _params) do
    IO.inspect(_params)
    players = Repo.all(Player)
    json(conn, players)
  end
end
