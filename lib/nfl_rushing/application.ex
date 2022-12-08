defmodule NflRushing.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  import Cachex.Spec

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      NflRushing.Repo,
      # Start the Telemetry supervisor
      NflRushingWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: NflRushing.PubSub},
      # Start the Endpoint (http/https)
      NflRushingWeb.Endpoint,
      # Start a worker by calling: NflRushing.Worker.start_link(arg)
      # {NflRushing.Worker, arg}
      %{
        id: NflRushing.Football.PlayerRepo.get_football_players_pagination_cache(),
        start:
          {Cachex, :start_link,
           [
             NflRushing.Football.PlayerRepo.get_football_players_pagination_cache(),
             [
               limit:
                 limit(
                   size: 10_000,
                   policy: Cachex.Policy.LRW,
                   # Reclaim 10% when hitting the cache limit
                   reclaim: 0.10
                 ),
               expiration:
                 expiration(
                   # how ofter Janitor runs
                   interval: :timer.seconds(15)
                 ),
               # Additional overhead not needed
               stats: false
             ]
           ]}
      }
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: NflRushing.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    NflRushingWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
