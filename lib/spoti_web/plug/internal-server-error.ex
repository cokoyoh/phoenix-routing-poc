defmodule Spoti.Plug.InternalServerError do
  import Plug.Conn
  alias Spoti.Errors.InternalServerError

  def init(opts), do: opts

  def call(conn, _opts) do
    respond(conn, 500, InternalServerError)
  end

  defp respond(conn, status, renderer) do
    if wants_json?(conn) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(status, renderer.json())
    else
      conn
      |> put_resp_content_type("text/html")
      |> send_resp(status, renderer.html())
    end
    |> halt()
  end

  defp wants_json?(conn) do
    Enum.any?(get_req_header(conn, "accept"), fn accept ->
      String.contains?(accept, "application/json")
    end)
  end
end
