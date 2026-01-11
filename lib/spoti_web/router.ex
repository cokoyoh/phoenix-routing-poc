defmodule SpotiWeb.Router do
  use Phoenix.Router

  pipeline :ingress do
    plug Plug.RequestId
    plug SpotiWeb.Plug.HeaderFirewall
    plug SpotiWeb.Plug.ServiceIdentity
  end

  scope "/", nil do
    pipe_through :ingress

    get "/athletics", SpotiWeb.Plug.ForwardToWebcore, []

    get "/athletics/:name",
      SpotiWeb.Plug.AthleticsPolicyPlug,
      SpotiWeb.Plug.ForwardToWebcore,
      []
  end
end
