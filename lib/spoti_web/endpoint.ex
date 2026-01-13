defmodule Spoti.Endpoint do
  use Phoenix.Endpoint, otp_app: :spoti_web

  plug Plug.RequestId
  plug Plug.Logger
  plug Spoti.Router
end
