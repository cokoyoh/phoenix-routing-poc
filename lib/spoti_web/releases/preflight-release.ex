defmodule Spoti.Releases.PreflightRelease do
  @behaviour Spoti.ReleasePlug

  require Logger
  import Plug.Conn

  alias Spoti.Runtime.SafeFetch
  alias Spoti.PreflightFetchers.FABL
  alias Spoti.Errors.InternalServerError

  def init(opts), do: opts

  def call(conn, _opts) do
    env = conn.assigns.env

    case SafeFetch.fetch(FABL, module: "example-dependency", conn: conn) do
      {:ok, data} ->
        route(conn, env, data)

      :error ->
        Logger.error("Release preflight failed — aborting request",
          request_id: request_id(conn),
          env: env
        )

        respond_500(conn)
    end
  end

  # -------------------------
  # Routing
  # -------------------------

  defp route(conn, env, data) do
    target =
      if data["isProd"] == true do
        :webcore
      else
        :legacy
      end

    Logger.info("Routing decision",
      request_id: request_id(conn),
      env: env,
      target: target
    )

    Spoti.Forwarders.ForwardByStrategy.forward(conn, target)
  end

  # -------------------------
  # Failure response
  # -------------------------

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
