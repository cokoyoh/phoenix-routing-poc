defmodule SpotiWeb.Plug.Forbidden do
  import Plug.Conn
  alias SpotiWeb.Errors.Forbidden

  def init(opts), do: opts

  def call(conn, _opts) do
    respond(conn, 403, Forbidden)
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
    Enum.any?(get_req_header(conn, "accept"), &String.contains?(&1, "application/json"))
  end
end
