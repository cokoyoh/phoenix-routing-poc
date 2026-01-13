defmodule Spoti.Plug.PolicyFailure do
  def not_found(conn) do
    Spoti.Plug.NotFound.call(conn, [])
  end

  def internal_error(conn) do
    Spoti.Plug.InternalServerError.call(conn, [])
  end
end
