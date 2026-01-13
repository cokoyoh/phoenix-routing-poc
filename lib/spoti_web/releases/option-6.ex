defmodule SpotiWeb.Releases.Option6Release do
  @behaviour SpotiWeb.ReleasePlug

  alias SpotiWeb.EnvGate
  alias SpotiWeb.ReleaseGates
  alias SpotiWeb.Forwarders.{ForwardToWebcore, ForwardToLegacy}

  @gates %{
    test: EnvGate.new(allow: ["alpha", "beta"]),
    prod: EnvGate.new(allow: ["stable"])
  }

  def init(opts), do: opts

  def call(%{params: %{"name" => name}} = conn, _opts) do
    if ReleaseGates.allowed?(@gates, conn.assigns.env, name) do
      ForwardToWebcore.call(conn, [])
    else
      ForwardToLegacy.call(conn, [])
    end
  end
end
