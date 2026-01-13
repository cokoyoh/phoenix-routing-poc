defmodule Spoti.Runtime.SafeFetch do
  @timeout 150

  def fetch(fetcher, opts) do
    try do
      fetcher.fetch(opts, timeout: @timeout)
    rescue
      _ -> :error
    catch
      _ -> :error
    end
  end
end
