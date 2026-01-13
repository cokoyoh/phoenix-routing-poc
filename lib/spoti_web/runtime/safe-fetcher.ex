defmodule Spoti.Runtime.SafeFetch do
  require Logger

  @timeout 1_000

  def fetch(fetcher, opts) do
    try do
      fetcher.fetch(opts, timeout: @timeout)
    rescue
      e ->
        Logger.error("SafeFetch rescue",
          error: Exception.message(e),
          stacktrace: __STACKTRACE__
        )

        :error
    catch
      kind, reason ->
        Logger.error("SafeFetch catch",
          kind: kind,
          reason: inspect(reason)
        )

        :error
    end
  end
end
