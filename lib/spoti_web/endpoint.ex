defmodule SpotiWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :spoti_web

  # We only need basic Plug functionality
  plug Plug.RequestId
  plug Plug.Logger

  plug SpotiWeb.Router
end
