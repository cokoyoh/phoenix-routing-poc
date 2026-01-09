defmodule SpotiWeb.ForwardController do
  use SpotiWeb, :controller

  @web Application.compile_env(:spoti_web, :web_platform_url)

  def to_web(conn, _params) do
    {:ok, body} =
      HTTPoison.get!(
        @web <> conn.request_path,
        conn.req_headers
      )
      |> Map.fetch!(:body)

    send_resp(conn, 200, body)
  end
end

