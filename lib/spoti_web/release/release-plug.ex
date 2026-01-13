defmodule SpotiWeb.ReleasePlug do
  @moduledoc """
  Contract for route-level release orchestration.
  """

  @callback call(Plug.Conn.t(), keyword()) :: Plug.Conn.t()
end
