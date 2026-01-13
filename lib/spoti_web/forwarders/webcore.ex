defmodule Spoti.Webcore do
  def init(opts), do: opts

  def call(conn, _opts) do
    Spoti.Forwarders.ForwardByStrategy.forward(conn, :webcore)
  end
end
