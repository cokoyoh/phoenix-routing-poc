defmodule SpotiWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :spoti_web

  plug Plug.RequestId
  plug Plug.Logger
  plug SpotiWeb.Router
end
