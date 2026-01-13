defmodule Spoti.Forwarders.Transport do
  require Logger
  import Plug.Conn

  def forward(conn, url) do
    case Req.request(
           method: conn.method,
           url: url,
           headers: conn.req_headers,
           body: conn.assigns[:raw_body]
         ) do
      {:ok, %Req.Response{status: status, body: body}} ->
        conn
        |> put_resp_content_type("text/html")
        |> send_resp(status, body)

      {:error, reason} ->
        Logger.error("""
        Downstream request failed
        url=#{url}
        reason=#{inspect(reason)}
        """)

        Spoti.Plug.PolicyFailure.internal_error(conn)
    end
  end
end
