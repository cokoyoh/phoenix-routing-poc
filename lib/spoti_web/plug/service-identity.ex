defmodule Spoti.Plug.ServiceIdentity do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    env = resolve_env_from_host(conn.host)

    request_id =
      conn
      |> get_req_header("x-request-id")
      |> List.first()

    conn
    |> assign(:env, env)
    |> put_req_header("x-spoti-env", Atom.to_string(env))
    |> maybe_put_req_header("x-spoti-request-id", request_id)
    |> put_req_header("x-spoti-origin-host", conn.host)
    |> put_req_header("x-spoti-caller", "phoenix-routing")
    |> put_req_header("authorization", "Bearer MOCK_SERVICE_TOKEN")
  end

  defp maybe_put_req_header(conn, _key, nil), do: conn
  defp maybe_put_req_header(conn, key, value),
    do: put_req_header(conn, key, value)

  defp resolve_env_from_host(host) do
    cond do
      host == "spoti.co.ke" ->
        :prod

      String.ends_with?(host, ".test.spoti.co.ke") ->
        :test

      String.ends_with?(host, ".live.spoti.co.ke") ->
        :prod

      true ->
        :test
    end
  end
end
