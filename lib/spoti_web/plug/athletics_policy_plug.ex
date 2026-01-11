defmodule SpotiWeb.Plug.AthleticsPolicyPlug do
  import Plug.Conn

  @env Application.compile_env(:spoti_web, :env)

  def init(opts), do: opts

  def call(%{params: %{"name" => name}} = conn, _opts) do
    if SpotiWeb.RoutePolicies.AthleticsPolicy.allowed?(@env, name) do
      conn
    else
      conn
      |> send_resp(404, "Not Found")
      |> halt()
    end
  end

  def call(conn, _opts), do: conn
end
