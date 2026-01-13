defmodule Spoti.Releases.PlatformRelease do
  @behaviour Spoti.ReleasePlug

  alias Spoti.Forwarders.ForwardByStrategy
  alias Spoti.Release

  @env_map %{
    prod: :legacy,
    test: :webcore
  }

  def init(opts), do: opts

  def call(conn, _opts) do
    strategy = Release.by_env(@env_map)

    target = strategy.(conn.assigns.env, nil)

    ForwardByStrategy.forward(conn, target)
  end
end
