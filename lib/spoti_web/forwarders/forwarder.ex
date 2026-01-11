defmodule SpotiWeb.Forwarders.Forwarder do
  def forward(conn, target_url) do
    url = target_url <> conn.request_path <> "?" <> conn.query_string

    response =
      HTTPoison.request!(
        conn.method,
        url,
        conn.req_headers,
        conn.body_params
      )

    Plug.Conn.send_resp(
      conn,
      response.status_code,
      response.body
    )
  end
end

