defmodule SpotiWeb.Plug.NotFound do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    conn
    |> send_resp(404, "Not found")
    |> halt()
  end
end
