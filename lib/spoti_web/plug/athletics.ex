defmodule SpotiWeb.Plugs.AthleticsPolicyPlug do
  import Plug.Conn

  @env Application.compile_env(:spoti_web, :env)

  def init(opts), do: opts

  def call(%{params: %{"name" => name}} = conn, _opts) do
    if SpotiWeb.RoutePolicies.AthleticsPolicy.allowed?(@env, name) do
      conn
    else
      send_resp(conn, 404, "Not Found")
      |> halt()
    end
  end
end
