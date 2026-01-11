defmodule RoutingPoc.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SpotiWeb.Telemetry,
      SpotiWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: RoutingPoc.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
