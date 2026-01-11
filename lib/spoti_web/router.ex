defmodule SpotiWeb.Router do
  use Phoenix.Router

  pipeline :ingress do
    plug Plug.RequestId
    plug SpotiWeb.Plug.HeaderFirewall
    plug SpotiWeb.Plug.ServiceIdentity
  end

  scope "/", SpotiWeb do
    pipe_through :ingress

    get "/", Plug.ForwardToWebcore, []

    get "/athletics", Plug.ForwardToWebcore, []

    get "/athletics/:name",
      Plug.AthleticsPolicyPlug,
      Plug.ForwardToWebcore
  end
end
