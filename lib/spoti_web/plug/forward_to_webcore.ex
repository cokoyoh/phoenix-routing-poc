defmodule SpotiWeb.Plugs.ForwardToWebcore do
  def init(opts), do: opts
  def call(conn, _opts) do
    SpotiWeb.Forwarders.Webcore.forward(conn)
  end
end
