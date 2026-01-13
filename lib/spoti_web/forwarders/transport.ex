defmodule SpotiWeb.Forwarders.Transport do
  def forward(conn, target_url) do
    url =
      target_url <>
        conn.request_path <>
        if(conn.query_string != "", do: "?" <> conn.query_string, else: "")

    resp =
      Req.request!(
        method: conn.method,
        url: url,
        headers: conn.req_headers
      )

    Plug.Conn.send_resp(conn, resp.status, resp.body)
  end
end
