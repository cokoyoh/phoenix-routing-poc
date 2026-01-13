defmodule SpotiWeb.Plug.AthleticsPolicyPlug do
  def init(opts), do: opts

  def call(%{assigns: %{spoti_env: env}, params: %{"name" => name}} = conn, _opts) do
    if SpotiWeb.RoutePolicies.AthleticsPolicy.allowed?(env, name) do
      conn
    else
      SpotiWeb.Plug.PolicyFailure.not_found(conn)
    end
  end

  def call(conn, _opts), do: conn
end
