defmodule Spoti.Releases.EnvPathRelease do
  @behaviour Spoti.ReleasePlug

  alias Spoti.EnvGate
  alias Spoti.Release
  alias Spoti.Forwarders.ForwardByStrategy

  @fallback :legacy

  @gates %{
    test: EnvGate.new(allow: ["alpha", "beta"]),
    prod: EnvGate.new(allow: ["stable"])
  }

  def init(opts), do: opts

  def call(%{params: %{"name" => name}} = conn, _opts) do
    env = conn.assigns.env

    strategy =
      Release.by_runtime(fn _name ->
        if allowed?(env, name), do: :webcore, else: :legacy
      end)

    target =
      try do
        strategy.(env, name)
      rescue
        _ -> @fallback
      end

    ForwardByStrategy.forward(conn, target)
  end

  def call(conn, _opts) do
    # Defensive fallback if :name is missing
    ForwardByStrategy.forward(conn, @fallback)
  end

  # -------------------------
  # Internal
  # -------------------------

  defp allowed?(env, name) do
    case Map.fetch(@gates, env) do
      {:ok, gate} -> EnvGate.allowed?(gate, name)
      :error -> true
    end
  end
end
