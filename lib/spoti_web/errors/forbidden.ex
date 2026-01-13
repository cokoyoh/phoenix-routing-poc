defmodule SpotiWeb.Errors.Forbidden do
  def html do
    SpotiWeb.Errors.Layout.render(
      "403 — Forbidden",
      "You are not allowed to access this resource."
    )
  end

  def json do
    ~s({"error":"forbidden"})
  end
end
