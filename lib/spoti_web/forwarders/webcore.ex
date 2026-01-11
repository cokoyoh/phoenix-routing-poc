defmodule SpotiWeb.Forwarders.Webcore do
  @target Application.compile_env(:spoti_web, :webcore_url)

  def forward(conn) do
    conn
    |> Plug.Conn.put_req_header("x-spoti-platform", "webcore")
    |> Plug.Conn.put_req_header("x-webcore-mode", "modern")
    |> SpotiWeb.Forwarders.Forwarder.forward(@target)
  end
end
