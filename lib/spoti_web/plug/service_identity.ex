defmodule SpotiWeb.Plug.ServiceIdentity do
  import Plug.Conn

  @env Application.compile_env(:spoti_web, :env)

  def init(opts), do: opts

  def call(conn, _opts) do
    request_id =
      get_resp_header(conn, "x-request-id")
      |> List.first()

    conn
    |> put_req_header("x-spoti-env", Atom.to_string(@env))
    |> put_req_header("x-spoti-request-id", request_id)
    |> put_req_header("x-spoti-origin-host", conn.host)
    |> put_req_header("x-spoti-caller", "phoenix-routing")
    |> put_req_header("authorization", "Bearer MOCK_SERVICE_TOKEN")
  end
end
