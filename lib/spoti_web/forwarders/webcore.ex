defmodule SpotiWeb.Forwarders.Webcore do
  def forward(conn) do
    target =
      Application.fetch_env!(:spoti_web, :webcore_url)

    conn
    |> Plug.Conn.put_req_header("x-spoti-platform", "webcore")
    |> Plug.Conn.put_req_header("x-webcore-mode", "modern")
    |> SpotiWeb.Forwarders.Forwarder.forward(target)
  end
end
