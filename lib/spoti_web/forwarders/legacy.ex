defmodule SpotiWeb.Forwarders.ForwardToLegacy do
  def init(opts), do: opts

  def call(conn, _opts) do
    SpotiWeb.Forwarders.ForwardByStrategy.forward(conn, :legacy)
  end
end
