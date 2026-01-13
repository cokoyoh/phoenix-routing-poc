defmodule Spoti.PreflightFetchers.FABL do
  @moduledoc """
  FABL preflight fetcher.

  Responsibilities:
  - Build a FABL-compatible GET request
  - Forward path + params context
  - Parse JSON responses
  - Return {:ok, data} | :error

  Safety (timeouts, retries, circuit breaking) is handled upstream
  by SafeFetch.
  """

  require Logger
  import Plug.Conn

  @base_url Application.compile_env(:spoti_web, :fabl_base_url)

  def fetch(opts, config) do
    module  = Keyword.fetch!(opts, :module)
    conn    = Keyword.fetch!(opts, :conn)
    timeout = Keyword.get(config, :timeout, 1_000)

    # Ensure query params are materialized (router-only pipelines)
    conn = fetch_query_params(conn)

    query =
      conn.query_params
      |> Map.merge(conn.path_params)
      |> Map.put("path", conn.request_path)

    url = "#{@base_url}/module/#{module}"

    Logger.debug("FABL request",
      request_id: request_id(conn),
      url: url,
      query: query,
      timeout: timeout
    )

    case Req.get(url,
           params: query,
           receive_timeout: timeout
         ) do
      {:ok, %Req.Response{status: 200, body: %{"data" => data}}} ->
        Logger.debug("FABL response OK",
          request_id: request_id(conn),
          data: preview(data)
        )

        {:ok, data}

      {:ok, %Req.Response{status: status, body: body}} ->
        Logger.warning("FABL non-200 response",
          request_id: request_id(conn),
          status: status,
          body: preview(body),
          reason: "non_200"
        )

        :error

      {:error, reason} ->
        Logger.error("FABL request failed",
          request_id: request_id(conn),
          reason: inspect(reason)
        )

        :error
    end
  end

  # -------------------------
  # Helpers
  # -------------------------

  defp request_id(conn) do
    get_req_header(conn, "x-request-id")
    |> List.first()
  end

  # Prevent log explosions
  defp preview(term, max \\ 500) do
    term
    |> inspect(limit: :infinity, printable_limit: max)
    |> String.slice(0, max)
  end
end
