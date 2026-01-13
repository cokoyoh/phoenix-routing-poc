defmodule Spoti.Releases.EnvPathRelease do
  @behaviour Spoti.ReleasePlug

  import Plug.Conn

  alias Spoti.EnvGate
  alias Spoti.Forwarders.ForwardByStrategy
  alias Spoti.Errors.NotFound

  @gates %{
    test: EnvGate.new(allow: ["alpha", "beta"]),
    prod: EnvGate.new(allow: ["stable"])
  }

  def init(opts), do: opts

  def call(%{params: %{"name" => name}} = conn, _opts) do
    env = conn.assigns.env

    if allowed?(env, name) do
      ForwardByStrategy.forward(conn, :webcore)
    else
      respond_404(conn)
    end
  end

  def call(conn, _opts) do
    respond_404(conn)
  end

  defp allowed?(env, name) do
    case Map.fetch(@gates, env) do
      {:ok, gate} -> EnvGate.allowed?(gate, name)
      :error -> false
    end
  end

  defp respond_404(conn) do
    conn
    |> put_resp_content_type("text/html")
    |> send_resp(404, NotFound.html())
    |> halt()
  end
end
