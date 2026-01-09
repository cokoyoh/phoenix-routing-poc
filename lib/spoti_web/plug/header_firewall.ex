defmodule SpotiWeb.Plug.HeaderFirewall do
  import Plug.Conn

  @allowed_headers ~w(accept accept-language)

  def init(opts), do: opts

  def call(conn, _opts) do
    clean =
      conn.req_headers
      |> Enum.filter(fn {k, _} -> k in @allowed_headers end)

    %{conn | req_headers: clean}
  end
end
