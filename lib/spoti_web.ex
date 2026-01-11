defmodule SpotiWeb do
  @moduledoc """
  The web interface for the routing gateway.

  In this PoC, this module exists only to provide
  Phoenix macros for routers and plugs.
  """

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
    end
  end

  def plug do
    quote do
      import Plug.Conn
    end
  end
end
