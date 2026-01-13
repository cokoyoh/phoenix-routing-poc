defmodule SpotiWeb.Releases.Option3Release do
  @behaviour SpotiWeb.ReleasePlug

  alias SpotiWeb.Forwarders.ForwardByStrategy
  alias SpotiWeb.Release

  @strategy Release.by_env(%{
    test: :webcore,
    prod: :legacy
  })

  def init(opts), do: opts

  def call(conn, _opts) do
    target = @strategy.(conn.assigns.env, nil)
    ForwardByStrategy.forward(conn, target)
  end
end
