defmodule SpotiWeb.Forwarders.ForwardToWebcore do
  def init(opts), do: opts

  def call(conn, _opts) do
    SpotiWeb.Forwarders.ForwardByStrategy.forward(conn, :webcore)
  end
end
