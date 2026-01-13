defmodule SpotiWeb.Plug.PolicyFailure do
  def not_found(conn) do
    SpotiWeb.Plug.NotFound.call(conn, [])
  end

  def internal_error(conn) do
    SpotiWeb.Plug.InternalServerError.call(conn, [])
  end
end
