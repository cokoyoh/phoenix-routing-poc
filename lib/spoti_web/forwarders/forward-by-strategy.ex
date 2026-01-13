defmodule SpotiWeb.Forwarders.ForwardByStrategy do
  import Plug.Conn

  @targets %{
    webcore: Application.compile_env(:spoti_web, :webcore_url),
    legacy: Application.compile_env(:spoti_web, :legacy_url)
  }

  def forward(conn, target) do
    conn
    |> add_platform_headers(target)
    |> SpotiWeb.Forwarders.Transport.forward(@targets[target])
  end

  defp add_platform_headers(conn, :webcore) do
    conn
    |> put_req_header("x-spoti-platform", "webcore")
  end

  defp add_platform_headers(conn, :legacy) do
    conn
    |> put_req_header("x-spoti-platform", "legacy")
  end
end
