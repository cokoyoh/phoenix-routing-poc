defmodule Spoti.Router do
  use Phoenix.Router

  pipeline :ingress do
    plug Plug.RequestId
    plug Spoti.Plug.HeaderFirewall
    plug Spoti.Plug.ServiceIdentity
  end

  scope "/" do
    pipe_through :ingress

    get "/", Spoti.Webcore, []

    get "/sample/route/2", Spoti.Legacy, []
    get "/sample/route/3", Spoti.Releases.PlatformRelease, []
    get "/sample/route/5", Spoti.Releases.PreflightRelease, []
    get "/sample/route/6/:name", Spoti.Releases.EnvPathRelease, []

    if Mix.env() == :test do
      use Spoti.TestRoutes
    end
  end

  match :*, "/*path", Spoti.Plug.NotFound, []
end
