defmodule Spoti.Releases.EnvPathRelease do
  @behaviour Spoti.ReleasePlug

  alias Spoti.EnvGate
  alias Spoti.ReleaseGates
  alias Spoti.Forwarders.ForwardByStrategy

  @fallback :legacy

  @gates %{
    test: EnvGate.new(allow: ["alpha", "beta"]),
    prod: EnvGate.new(allow: ["stable"])
  }

  def init(opts), do: opts

  def call(%{params: %{"name" => name}} = conn, _opts) do
    target =
      try do
        if ReleaseGates.allowed?(@gates, conn.assigns.env, name) do
          :webcore
        else
          :legacy
        end
      rescue
        _ -> @fallback
      end

    ForwardByStrategy.forward(conn, target)
  end

  def call(conn, _opts) do
    # defensive fallback if :name is missing
    ForwardByStrategy.forward(conn, @fallback)
  end
end
