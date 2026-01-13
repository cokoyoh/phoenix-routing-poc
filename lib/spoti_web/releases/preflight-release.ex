defmodule Spoti.Releases.PreflightRelease do
  @behaviour Spoti.ReleasePlug

  require Logger
  import Plug.Conn

  alias Spoti.Runtime.SafeFetch
  alias Spoti.PreflightFetchers.FABL
  alias Spoti.Release
  alias Spoti.Errors.InternalServerError
  alias Spoti.Forwarders.ForwardByStrategy

  def init(opts), do: opts

  def call(conn, _opts) do
    env = conn.assigns.env

    strategy =
      Release.by_runtime(fn data ->
        if data["isProd"] == true, do: :webcore, else: :legacy
      end)

    case SafeFetch.fetch(FABL, module: "example-dependency", conn: conn) do
      {:ok, data} ->
        target = strategy.(env, data)
        ForwardByStrategy.forward(conn, target)

      :error ->
        Logger.error("Release preflight failed — aborting request",
          request_id: request_id(conn),
          env: env,
          release: __MODULE__
        )

        respond_500(conn)
    end
  end

  defp respond_500(conn) do
    conn
    |> put_resp_content_type("text/html")
    |> send_resp(500, InternalServerError.html())
    |> halt()
  end

  defp request_id(conn) do
    get_req_header(conn, "x-request-id")
    |> List.first()
  end
end
