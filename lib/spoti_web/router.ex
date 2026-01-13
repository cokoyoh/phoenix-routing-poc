defmodule SpotiWeb.Router do
  use Phoenix.Router

  pipeline :ingress do
    plug Plug.RequestId
    plug SpotiWeb.Plug.HeaderFirewall
    plug SpotiWeb.Plug.ServiceIdentity
  end

  scope "/", SpotiWeb do
    pipe_through :ingress

    scope "/", as: :webcore do
      get "/", Plug.ForwardToWebcore, []

      get "/athletics", Plug.ForwardToWebcore, []

      get "/athletics/:name",
        Plug.AthleticsPolicyPlug,
        Plug.ForwardToWebcore
    end
  end

  # HARD FAIL: everything else
  match :*, "/*path", SpotiWeb.Plug.NotFound, []
end
