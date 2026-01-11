defmodule SpotiWeb.Plugs.ForwardToLegacy do
  def init(opts), do: opts
  def call(conn, _opts) do
    SpotiWeb.Forwarders.Legacy.forward(conn)
  end
end
