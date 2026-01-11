defmodule SpotiWeb.Forwarders.Legacy do
  @target Application.compile_env(:spoti_web, :legacy_url)

  def forward(conn) do
    conn
    |> Plug.Conn.put_req_header("x-spoti-platform", "legacy")
    |> SpotiWeb.Forwarders.Forwarder.forward(@target)
  end
end
