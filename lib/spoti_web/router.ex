defmodule SpotiWeb.Router do
  use Phoenix.Router

  pipeline :ingress do
    plug Plug.RequestId
    plug SpotiWeb.Plug.HeaderFirewall
    plug SpotiWeb.Plug.ServiceIdentity
  end

  scope "/", SpotiWeb do
    pipe_through :ingress

    get "/sample/route/1", ForwardToWebcore, []
    get "/sample/route/2", ForwardToLegacy, []
    get "/sample/route/3", SpotiWeb.Releases.Option3Release, []
    get "/sample/route/5", SpotiWeb.Releases.Option5Release, []
    get "/sample/route/6/:name", SpotiWeb.Releases.Option6Release, []

    # hard fail stays as-is
    match :*, "/*path", SpotiWeb.Plug.NotFound, []
  end
end
