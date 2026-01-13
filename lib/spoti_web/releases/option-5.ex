defmodule SpotiWeb.Releases.Option5Release do
  @behaviour SpotiWeb.ReleasePlug

  alias SpotiWeb.Runtime.SafeFetch
  alias SpotiWeb.PreflightFetchers.FABL
  alias SpotiWeb.Release
  alias SpotiWeb.Forwarders.ForwardByStrategy

  @fallback :legacy

  @strategy Release.env_then_runtime(
              :webcore,
              fn data ->
                if data["isProd"], do: :webcore, else: :legacy
              end
            )

  def init(opts), do: opts

  def call(conn, _opts) do
    data =
      case SafeFetch.fetch(FABL, module: "release-check", conn: conn) do
        {:ok, data} -> data
        :error -> nil
      end

    target =
      try do
        @strategy.(conn.assigns.env, data)
      rescue
        _ -> @fallback
      end

    ForwardByStrategy.forward(conn, target)
  end
end
