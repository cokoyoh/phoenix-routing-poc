defmodule SpotiWeb.Errors.NotFound do
  def html do
    SpotiWeb.Errors.Layout.render(
      "404 — Page not found",
      "The page you requested does not exist."
    )
  end

  def json do
    ~s({"error":"not_found"})
  end
end
