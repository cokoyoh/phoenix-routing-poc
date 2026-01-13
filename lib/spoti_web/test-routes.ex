defmodule Spoti.TestRoutes do
  defmacro __using__(_opts) do
    quote do
      get "/sample/route/1", Spoti.Webcore, []
    end
  end
end
