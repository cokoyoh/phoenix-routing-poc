defmodule Spoti.Releases.PreflightRelease do
  @behaviour Spoti.ReleasePlug

  alias Spoti.Runtime.SafeFetch
  alias Spoti.PreflightFetchers.FABL
  alias Spoti.Release
  alias Spoti.Forwarders.ForwardByStrategy

  @fallback :legacy

  def init(opts), do: opts

  def call(conn, _opts) do
    data =
      case SafeFetch.fetch(FABL, module: "release-check", conn: conn) do
        {:ok, data} -> data
        :error -> nil
      end

    strategy =
      Release.env_then_runtime(
        :webcore,
        fn data ->
          if data["isProd"], do: :webcore, else: :legacy
        end
      )

    target =
      try do
        strategy.(conn.assigns.env, data)
      rescue
        _ -> @fallback
      end

    ForwardByStrategy.forward(conn, target)
  end
end
