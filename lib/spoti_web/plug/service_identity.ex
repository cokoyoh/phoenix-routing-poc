defmodule SpotiWeb.Plug.ServiceIdentity do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    case resolve_env_from_host(conn.host) do
      {:ok, env} ->
        request_id =
          get_resp_header(conn, "x-request-id")
          |> List.first()

        conn
        |> assign(:spoti_env, env)
        |> put_req_header("x-spoti-env", Atom.to_string(env))
        |> put_req_header("x-spoti-request-id", request_id)
        |> put_req_header("x-spoti-origin-host", conn.host)
        |> put_req_header("x-spoti-caller", "phoenix-routing")
        |> put_req_header("authorization", "Bearer MOCK_SERVICE_TOKEN")

      :error ->
        SpotiWeb.Plug.PolicyFailure.internal_error(conn)
    end
  end

  defp resolve_env_from_host(host) do
    cond do
      host == "spoti.co.ke" ->
        {:ok, :prod}

      String.ends_with?(host, ".test.spoti.co.ke") ->
        {:ok, :test}

      String.ends_with?(host, ".live.spoti.co.ke") ->
        {:ok, :prod}

      true ->
        :error
    end
  end
end
