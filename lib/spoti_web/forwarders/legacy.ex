defmodule Spoti.Legacy do
  def init(opts), do: opts

  def call(conn, _opts) do
    Spoti.Forwarders.ForwardByStrategy.forward(conn, :legacy)
  end
end
