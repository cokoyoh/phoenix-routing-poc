defmodule SpotiWeb.Router do
  use SpotiWeb, :router

  @env Application.compile_env(:spoti_web, :env)
  @allowed_hosts Application.compile_env(:spoti_web, :allowed_hosts)

  pipeline :ingress do
    plug :accepts, ["html", "json"]
    plug SpotiWeb.Plug.HeaderFirewall
    plug SpotiWeb.Plug.ServiceIdentity
  end

  scope "/", SpotiWeb do
    pipe_through :ingress

    get "/athletics", ForwardController, :to_web
  end

  def call(conn, opts) do
    if conn.host =~ @allowed_hosts do
      super(conn, opts)
    else
      send_resp(conn, 421, "Misdirected Request")
    end
  end
end
